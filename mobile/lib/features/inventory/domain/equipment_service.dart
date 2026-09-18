import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vagabond_hero/core/database/app_database.dart';
import 'package:vagabond_hero/core/database/database_providers.dart';

final equipmentServiceProvider = Provider<EquipmentService>((ref) {
  return EquipmentService(ref.read(databaseProvider));
});

class EquipmentService {
  final AppDatabase _db;
  EquipmentService(this._db);

  /// Equip an item. Unequips anything in the same slot first.
  /// If [targetSlot] is provided, uses that slot; otherwise uses [item.equipSlot].
  Future<void> equip(ItemData item, {String? targetSlot}) async {
    String? slot = targetSlot ?? item.equipSlot;
    if (slot == null) return;

    // If it's a Ring without a specific targetSlot, pick empty ring slot if available
    if (item.baseType == 'Ring' && targetSlot == null) {
      final equippedRings = await (_db.select(_db.items)
            ..where((i) =>
                (i.equipSlot.equals('RingL') | i.equipSlot.equals('RingR')) &
                i.isEquipped.equals(true) &
                i.ownerId.equals(1)))
          .get();
      final hasRingL = equippedRings.any((r) => r.equipSlot == 'RingL');
      final hasRingR = equippedRings.any((r) => r.equipSlot == 'RingR');

      if (!hasRingL) {
        slot = 'RingL';
      } else if (!hasRingR) {
        slot = 'RingR';
      } else {
        slot = 'RingL'; // default override
      }
    }

    final finalSlot = slot;
    await _db.transaction(() async {
      // Unequip current occupant of that slot
      await (_db.update(_db.items)
            ..where((i) =>
                i.equipSlot.equals(finalSlot) &
                i.isEquipped.equals(true) &
                i.ownerId.equals(1)))
          .write(const ItemsCompanion(isEquipped: Value(false)));

      // Equip the chosen item with the designated slot
      await (_db.update(_db.items)..where((i) => i.id.equals(item.id)))
          .write(ItemsCompanion(
        isEquipped: const Value(true),
        equipSlot: Value(finalSlot),
      ));
    });
  }

  /// Unequip an item (move to bag).
  Future<void> unequip(ItemData item) async {
    await (_db.update(_db.items)..where((i) => i.id.equals(item.id)))
        .write(const ItemsCompanion(isEquipped: Value(false)));
  }

  /// Deposit an item into the town safe (must not be equipped)
  Future<void> depositToSafe(ItemData item) async {
    await (_db.update(_db.items)..where((i) => i.id.equals(item.id))).write(
      const ItemsCompanion(
        isEquipped: Value(false),
        isStoredInSafe: Value(true),
      ),
    );
  }

  /// Withdraw an item from the town safe back into the satchel bag
  Future<void> withdrawFromSafe(ItemData item) async {
    await (_db.update(_db.items)..where((i) => i.id.equals(item.id))).write(
      const ItemsCompanion(
        isStoredInSafe: Value(false),
      ),
    );
  }

  /// Drops an item from inventory onto the ground of the current room
  Future<void> dropItem(ItemData item) async {
    final player = await (_db.select(_db.players)..where((t) => t.id.equals(1))).getSingleOrNull();
    final roomId = player?.currentRoomId ?? 101;

    await (_db.update(_db.items)..where((i) => i.id.equals(item.id))).write(
      ItemsCompanion(
        ownerId: const Value(null),
        groundRoomId: Value(roomId),
        isEquipped: const Value(false),
        isStoredInSafe: const Value(false),
      ),
    );
  }

  /// Use a consumable item (e.g., Potion, Elixir, Ration), restoring HP and removing or decrementing it
  Future<String> useConsumable(ItemData item) async {
    final player = await (_db.select(_db.players)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (player == null) return 'No active player.';

    int healAmount = 35; // Default heal amount
    try {
      if (item.modifiersJson.trim().isNotEmpty) {
        final decoded = jsonDecode(item.modifiersJson);
        if (decoded is Map<String, dynamic>) {
          if (decoded['healAmount'] != null) {
            healAmount = (decoded['healAmount'] as num).toInt();
          }
        }
      }
    } catch (_) {}

    final newHp = (player.currentHp + healAmount).clamp(0, player.baseHp);
    final actualHealed = newHp - player.currentHp;

    await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
      PlayersCompanion(currentHp: Value(newHp)),
    );

    // Delete or consume the used item from inventory
    await (_db.delete(_db.items)..where((i) => i.id.equals(item.id))).go();

    return 'Used ${item.name}! Restored +$actualHealed HP ($newHp/${player.baseHp}).';
  }
}
