import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../combat/domain/combat_engine.dart';

enum Direction { north, south, east, west }

final navigationControllerProvider = Provider<NavigationController>((ref) {
  final db = ref.watch(databaseProvider);
  return NavigationController(db, ref);
});

class NavigationController {
  final AppDatabase _db;
  final Ref _ref;

  NavigationController(this._db, this._ref);

  Future<bool> moveTo(Direction direction) async {
    final currentRoom = _ref.read(currentRoomStreamProvider).value;
    if (currentRoom == null) return false;

    int? targetRoomId;
    switch (direction) {
      case Direction.north:
        targetRoomId = currentRoom.northExitId;
        break;
      case Direction.south:
        targetRoomId = currentRoom.southExitId;
        break;
      case Direction.east:
        targetRoomId = currentRoom.eastExitId;
        break;
      case Direction.west:
        targetRoomId = currentRoom.westExitId;
        break;
    }

    if (targetRoomId == null) {
      return false; // Exit is blocked or does not exist
    }

    final validTargetId = targetRoomId;

    // Trigger subtle tactile step click
    HapticFeedback.selectionClick();

    // Stop auto-attack when moving between rooms
    _ref.read(combatEngineProvider).stopAutoAttack();

    // Update Player's current room
    await (_db.update(_db.players)..where((t) => t.id.equals(1))).write(
      PlayersCompanion(
        currentRoomId: Value(validTargetId),
      ),
    );

    // Mark newly visited room as explored
    await (_db.update(_db.rooms)..where((t) => t.id.equals(validTargetId))).write(
      const RoomsCompanion(
        isExplored: Value(true),
      ),
    );

    // Check if newly entered room has aggressive ambush mobs
    await _ref.read(combatEngineProvider).checkRoomAggroAmbush(validTargetId);

    return true;
  }
}
