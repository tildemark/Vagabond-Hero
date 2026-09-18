import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Streams player row dynamically
final playerStreamProvider = StreamProvider.autoDispose<PlayerData?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.players)..where((tbl) => tbl.id.equals(1)))
      .watchSingleOrNull();
});

// Streams current room based on player's currentRoomId
final currentRoomStreamProvider = StreamProvider.autoDispose<RoomData?>((ref) {
  final playerAsync = ref.watch(playerStreamProvider);
  final roomId = playerAsync.value?.currentRoomId ?? 101;
  final db = ref.watch(databaseProvider);
  return (db.select(db.rooms)..where((tbl) => tbl.id.equals(roomId)))
      .watchSingleOrNull();
});

// Streams mobs present in current room
final currentRoomMobsProvider = StreamProvider.autoDispose<List<MobData>>((ref) {
  final playerAsync = ref.watch(playerStreamProvider);
  final roomId = playerAsync.value?.currentRoomId ?? 101;
  final db = ref.watch(databaseProvider);
  return (db.select(db.mobs)
        ..where((tbl) => tbl.roomId.equals(roomId) & tbl.isAlive.equals(true)))
      .watch();
});

// Streams player's inventory
final playerInventoryProvider = StreamProvider.autoDispose<List<ItemData>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.items)..where((tbl) => tbl.ownerId.equals(1))).watch();
});

// Streams ALL rooms as a lookup map (used by minimap)
final allRoomsProvider = StreamProvider<Map<int, RoomData>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.rooms).watch().map((rows) {
    return {for (final r in rows) r.id: r};
  });
});

// Streams ALL active mobs mapped by roomId for tactical map overlays
final allActiveMobsByRoomProvider =
    StreamProvider<Map<int, List<MobData>>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.mobs)..where((tbl) => tbl.isAlive.equals(true)))
      .watch()
      .map((rows) {
    final map = <int, List<MobData>>{};
    for (final mob in rows) {
      map.putIfAbsent(mob.roomId, () => []).add(mob);
    }
    return map;
  });
});

