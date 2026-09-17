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
  Future<void> equip(ItemData item) async {
    final slot = item.equipSlot;
    if (slot == null) return;

    await _db.transaction(() async {
      // Unequip current occupant of that slot
      await (_db.update(_db.items)
            ..where((i) =>
                i.equipSlot.equals(slot) &
                i.isEquipped.equals(true) &
                i.ownerId.equals(1)))
          .write(const ItemsCompanion(isEquipped: Value(false)));

      // Equip the chosen item
      await (_db.update(_db.items)..where((i) => i.id.equals(item.id)))
          .write(const ItemsCompanion(isEquipped: Value(true)));
    });
  }

  /// Unequip an item (move to bag).
  Future<void> unequip(ItemData item) async {
    await (_db.update(_db.items)..where((i) => i.id.equals(item.id)))
        .write(const ItemsCompanion(isEquipped: Value(false)));
  }
}
