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
}
