import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/database/item_templates.dart';

final combatLogProvider =
    NotifierProvider<CombatLogNotifier, List<String>>(CombatLogNotifier.new);

class CombatLogNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [
      '[SYSTEM READY]: Tactical combat engine initialized.',
    ];
  }

  void addLog(String log) {
    state = [...state.take(20), log];
  }

  void clear() {
    state = [];
  }
}

final combatEngineProvider = Provider<CombatEngine>((ref) {
  final db = ref.watch(databaseProvider);
  return CombatEngine(db, ref);
});

class CombatEngine {
  final AppDatabase _db;
  final Ref _ref;
  final Random _rng = Random();

  CombatEngine(this._db, this._ref);

  Future<void> attackMob(MobData mob) async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return;

    final logNotifier = _ref.read(combatLogProvider.notifier);

    // 1. Player attack roll
    final weaponMin = 4;
    final weaponMax = 8;
    final dmgRoll =
        _rng.nextInt(weaponMax - weaponMin + 1) + weaponMin + (player.strength ~/ 3);
    final isCrit = _rng.nextDouble() < 0.15;
    final finalPlayerDmg = isCrit ? (dmgRoll * 1.8).toInt() : dmgRoll;

    if (isCrit) {
      HapticFeedback.heavyImpact();
      logNotifier.addLog(
          '⚡ CRITICAL STRIKE! You dealt $finalPlayerDmg damage to ${mob.name}!');
    } else {
      HapticFeedback.lightImpact();
      logNotifier.addLog('⚔️ You struck ${mob.name} for $finalPlayerDmg damage.');
    }

    final remainingMobHp = max(0, mob.currentHp - finalPlayerDmg);

    if (remainingMobHp <= 0) {
      // Mob defeated
      await (_db.update(_db.mobs)..where((t) => t.id.equals(mob.id))).write(
        const MobsCompanion(
          currentHp: Value(0),
          isAlive: Value(false),
        ),
      );

      final expGained = mob.expReward;
      final newExp = player.currentExp + expGained;
      final silverDrop = _rng.nextInt(15) + 10;

      HapticFeedback.mediumImpact();
      logNotifier.addLog(
          '💀 ${mob.name} was slain! Gained +$expGained EXP & $silverDrop Silver Prisms.');

      // Check level up
      if (newExp >= player.maxExp) {
        final newLevel = player.level + 1;
        final nextMaxExp = (player.maxExp * 1.5).toInt();
        await (_db.update(_db.players)..where((t) => t.id.equals(player.id)))
            .write(
          PlayersCompanion(
            level: Value(newLevel),
            currentExp: Value(newExp - player.maxExp),
            maxExp: Value(nextMaxExp),
            baseHp: Value(player.baseHp + 10),
            currentHp: Value(player.baseHp + 10),
            strength: Value(player.strength + 2),
            silverPrisms: Value(player.silverPrisms + silverDrop),
          ),
        );
        logNotifier.addLog('✨ LEVEL UP! You reached Level $newLevel!');
      } else {
        await (_db.update(_db.players)..where((t) => t.id.equals(player.id)))
            .write(
          PlayersCompanion(
            currentExp: Value(newExp),
            silverPrisms: Value(player.silverPrisms + silverDrop),
          ),
        );
      }

      // Check if this was the Act 1 Climax Boss (The Hollow Woodsman)
      if (mob.name == 'The Hollow Woodsman') {
        final currentActs = player.actsCompleted;
        if (currentActs < 1) {
          await (_db.update(_db.players)..where((t) => t.id.equals(player.id)))
              .write(
            const PlayersCompanion(
              actsCompleted: Value(1),
            ),
          );
          logNotifier.addLog(
              '🌀 [SYSTEM MILESTONE]: ACT I CONQUERED! Waypoint to ACT II (The Sunken City) Unlocked!');
        }
      }

      // Roll canonical item drop from kItemTemplates (50% drop rate, 100% for bosses)
      final dropRate = mob.isMiniBoss ? 1.0 : 0.50;
      if (_rng.nextDouble() <= dropRate && kItemTemplates.isNotEmpty) {
        final template = kItemTemplates[_rng.nextInt(kItemTemplates.length)];
        final droppedId = 'drop_${template.id}_${DateTime.now().millisecondsSinceEpoch}';
        
        final modJson = jsonEncode({
          'description': template.description,
          'modifiers': template.modifiers,
          'uniqueTrait': template.uniqueTrait,
          'reqLvl': template.reqLvl,
        });

        await _db.into(_db.items).insert(
          ItemsCompanion.insert(
            id: droppedId,
            name: template.name,
            baseType: template.baseType,
            rarity: Value(template.rarity),
            isEquipped: const Value(false),
            equipSlot: Value(template.equipSlot),
            minDamage: Value(template.minDamage),
            maxDamage: Value(template.maxDamage),
            armorValue: Value(template.armorValue),
            socketCount: Value(template.socketCount),
            modifiersJson: Value(modJson),
            ownerId: Value(player.id),
          ),
        );

        logNotifier.addLog('💎 Loot Discovered! Acquired [${template.name}] (${template.rarity})!');
      }

      return;
    }

    // Update mob current HP
    await (_db.update(_db.mobs)..where((t) => t.id.equals(mob.id))).write(
      MobsCompanion(
        currentHp: Value(remainingMobHp),
      ),
    );

    // 2. Mob counter-attack
    final mobDmg =
        _rng.nextInt(mob.maxDamage - mob.minDamage + 1) + mob.minDamage;
    final remainingPlayerHp = max(0, player.currentHp - mobDmg);

    logNotifier.addLog(
        '💥 ${mob.name} retaliates dealing $mobDmg damage! ($remainingPlayerHp HP left)');

    await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
      PlayersCompanion(
        currentHp: Value(remainingPlayerHp),
      ),
    );
  }

  /// Tactical retreat from an encounter (especially useful against rare mini-bosses)
  Future<bool> fleeCombat(MobData mob) async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return false;

    final currentRoom = _ref.read(currentRoomStreamProvider).value;
    if (currentRoom == null) return false;

    final logNotifier = _ref.read(combatLogProvider.notifier);

    // Find an escape route (south, west, or any available exit)
    final escapeRoomId = currentRoom.southExitId ??
        currentRoom.westExitId ??
        currentRoom.northExitId ??
        currentRoom.eastExitId;

    if (escapeRoomId == null) {
      logNotifier.addLog('⚠️ No escape route available! You are cornered!');
      return false;
    }

    // Flee check: Agility based or guaranteed for rare mini-bosses
    final fleeChance = 0.85;
    final success = _rng.nextDouble() < fleeChance;

    if (success) {
      HapticFeedback.selectionClick();
      await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
        PlayersCompanion(
          currentRoomId: Value(escapeRoomId),
        ),
      );
      // Mark escape room explored
      await (_db.update(_db.rooms)..where((t) => t.id.equals(escapeRoomId))).write(
        const RoomsCompanion(isExplored: Value(true)),
      );

      logNotifier.addLog(
          '🏃 [TACTICAL RETREAT]: You disengaged from ${mob.name} and fled back safely!');
      return true;
    } else {
      HapticFeedback.heavyImpact();
      // Minor scrape damage on failed flee
      final scrapeDmg = 2 + (mob.level);
      final remainingHp = max(1, player.currentHp - scrapeDmg);
      await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
        PlayersCompanion(currentHp: Value(remainingHp)),
      );
      logNotifier.addLog(
          '⚠️ Escape hindered! ${mob.name} struck you for $scrapeDmg as you pulled back!');
      return false;
    }
  }
}
