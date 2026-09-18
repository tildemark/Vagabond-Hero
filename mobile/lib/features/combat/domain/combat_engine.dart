import 'dart:async';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/database/item_templates.dart';

import '../../../features/character/domain/class_skills.dart';

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
    state = [...state.take(25), log];
  }

  void clear() {
    state = [];
  }
}

// Active Combat Status Badges / Buffs
class ActiveBuffsNotifier extends Notifier<Map<String, int>> {
  Timer? _ticker;

  @override
  Map<String, int> build() {
    ref.onDispose(() => _ticker?.cancel());
    return {};
  }

  void addBuff(String buffName, int durationSeconds) {
    final updated = Map<String, int>.from(state);
    updated[buffName] = durationSeconds;
    state = updated;
    _startTickerIfNeeded();
  }

  void removeBuff(String buffName) {
    if (!state.containsKey(buffName)) return;
    final updated = Map<String, int>.from(state)..remove(buffName);
    state = updated;
    if (state.isEmpty) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  void _startTickerIfNeeded() {
    if (_ticker != null) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isEmpty) {
        _ticker?.cancel();
        _ticker = null;
        return;
      }
      final next = <String, int>{};
      state.forEach((key, val) {
        if (val > 1) {
          next[key] = val - 1;
        }
      });
      state = next;
      if (state.isEmpty) {
        _ticker?.cancel();
        _ticker = null;
      }
    });
  }
}

final activeBuffsProvider =
    NotifierProvider<ActiveBuffsNotifier, Map<String, int>>(ActiveBuffsNotifier.new);

// Skill Cooldown Tracker: Maps skillId -> remaining seconds
class SkillCooldownNotifier extends Notifier<Map<String, int>> {
  Timer? _ticker;

  @override
  Map<String, int> build() {
    ref.onDispose(() => _ticker?.cancel());
    return {};
  }

  void triggerCooldown(String skillId, int seconds) {
    if (seconds <= 0) return;
    final updated = Map<String, int>.from(state);
    updated[skillId] = seconds;
    state = updated;
    _startTickerIfNeeded();
  }

  void _startTickerIfNeeded() {
    if (_ticker != null) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isEmpty) {
        _ticker?.cancel();
        _ticker = null;
        return;
      }
      final next = <String, int>{};
      state.forEach((skillId, remaining) {
        if (remaining > 1) {
          next[skillId] = remaining - 1;
        }
      });
      state = next;
      if (state.isEmpty) {
        _ticker?.cancel();
        _ticker = null;
      }
    });
  }

  int getCooldown(String skillId) => state[skillId] ?? 0;
  bool isReady(String skillId) => (state[skillId] ?? 0) <= 0;
}

final skillCooldownsProvider =
    NotifierProvider<SkillCooldownNotifier, Map<String, int>>(SkillCooldownNotifier.new);

// Player dynamic class resource (Grit, Fury, Energy, Mana, Animus)
class PlayerResourceNotifier extends Notifier<int> {
  Timer? _regenTimer;

  @override
  int build() {
    ref.onDispose(() => _regenTimer?.cancel());
    // Periodically regenerate or stabilize resource
    _regenTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _passiveTick();
    });
    return 60; // Initial default
  }

  void setResource(int val) => state = val;

  void consume(int amount) {
    state = max(0, state - amount);
  }

  void restore(int amount, int maxCap) {
    state = min(maxCap, state + amount);
  }

  void _passiveTick() {
    final player = ref.read(playerStreamProvider).value;
    if (player == null) return;

    final (_, _, maxVal, _) = getResourceInfo(player);
    switch (player.jobClass) {
      case 'Phantom' || 'Assassin' || 'Rift-Sniper':
        // Fast Energy regen
        restore(10, maxVal);
        break;
      case 'Weaver' || 'Elementalist' || 'Blood Mage':
        // Mana regen
        restore(5 + (player.intelligence ~/ 4), maxVal);
        break;
      case 'Warden' || 'Necromancer' || 'Druid':
        // Animus regen
        restore(6, maxVal);
        break;
      case 'Juggernaut' || 'Berserker' || 'Void-Knight':
        // Fury slowly decays out of combat or stays ready
        if (state > 30) {
          state = max(30, state - 2);
        }
        break;
      default:
        // Vagabond Grit regen
        restore(8, maxVal);
        break;
    }
  }

  static (String label, int current, int max, Color color) getResourceInfo(PlayerData player, [int? currentOverride]) {
    switch (player.jobClass) {
      case 'Juggernaut' || 'Berserker' || 'Void-Knight':
        return ('FURY', currentOverride ?? 35, 100, const Color(0xFFEF4444));
      case 'Phantom' || 'Assassin' || 'Rift-Sniper':
        return ('ENERGY', currentOverride ?? 80, 100, const Color(0xFFF59E0B));
      case 'Weaver' || 'Elementalist' || 'Blood Mage':
        final maxMp = 50 + player.intelligence * 5;
        return ('MANA', currentOverride ?? maxMp, maxMp, const Color(0xFF38BDF8));
      case 'Warden' || 'Necromancer' || 'Druid':
        return ('ANIMUS', currentOverride ?? 45, 100, const Color(0xFF10B981));
      default:
        return ('GRIT', currentOverride ?? 60, 100, const Color(0xFFB45309));
    }
  }
}

final playerResourceProvider =
    NotifierProvider<PlayerResourceNotifier, int>(PlayerResourceNotifier.new);

// Controls whether auto-attack is currently active
class AutoAttackNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
  void set(bool val) => state = val;
}

final isAutoAttackingProvider =
    NotifierProvider<AutoAttackNotifier, bool>(AutoAttackNotifier.new);

// Selected primary focused target mob ID (null means default first available mob)
class SelectedTargetNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  void select(int? id) => state = id;
}

final selectedTargetMobIdProvider =
    NotifierProvider<SelectedTargetNotifier, int?>(SelectedTargetNotifier.new);

final combatEngineProvider = Provider<CombatEngine>((ref) {
  final db = ref.watch(databaseProvider);
  final engine = CombatEngine(db, ref);
  ref.onDispose(() => engine.dispose());
  return engine;
});

class CombatEngine {
  final AppDatabase _db;
  final Ref _ref;
  final Random _rng = Random();
  Timer? _autoAttackTimer;

  CombatEngine(this._db, this._ref);

  void dispose() {
    _autoAttackTimer?.cancel();
  }

  /// Toggle Auto-Attack on / off
  void toggleAutoAttack() {
    final current = _ref.read(isAutoAttackingProvider);
    if (current) {
      stopAutoAttack();
    } else {
      startAutoAttack();
    }
  }

  void startAutoAttack() {
    _ref.read(isAutoAttackingProvider.notifier).set(true);
    _autoAttackTimer?.cancel();
    _autoAttackTimer = Timer.periodic(const Duration(milliseconds: 1100), (_) {
      _executeAutoAttackTick();
    });
    _ref.read(combatLogProvider.notifier).addLog('⚡ [AUTO-ATTACK]: Continuous combat loop ENGAGED.');
    HapticFeedback.mediumImpact();
  }

  void stopAutoAttack() {
    _autoAttackTimer?.cancel();
    _autoAttackTimer = null;
    _ref.read(isAutoAttackingProvider.notifier).set(false);
  }

  Future<void> _executeAutoAttackTick() async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null || player.currentHp <= 0) {
      stopAutoAttack();
      return;
    }

    final mobs = _ref.read(currentRoomMobsProvider).value ?? [];
    if (mobs.isEmpty) {
      stopAutoAttack();
      _ref.read(combatLogProvider.notifier).addLog('✨ [AUTO-ATTACK]: Sector secured. Combat loop disengaged.');
      return;
    }

    final targetId = _ref.read(selectedTargetMobIdProvider);
    MobData targetMob = mobs.firstWhere(
      (m) => m.id == targetId && m.isAlive,
      orElse: () => mobs.first,
    );

    // Auto-cast weaving: check if any unlocked active skill is ready & affordable!
    final allSkills = ClassSkillCatalog.getSkillsForClass(player.jobClass);
    final cooldownTracker = _ref.read(skillCooldownsProvider);
    final currentResource = _ref.read(playerResourceProvider);

    // Filter unlocked active skills that are off cooldown and can be afforded
    final readyActiveSkills = allSkills.where((s) {
      if (s.type != SkillType.active) return false;
      if (player.level < s.requiredLevel) return false;
      final cd = cooldownTracker[s.id] ?? 0;
      if (cd > 0) return false;
      if (s.numericCost > currentResource) return false;
      return true;
    }).toList();

    if (readyActiveSkills.isNotEmpty) {
      // Pick the highest level ready active skill or emergency triage if low HP
      ClassSkill skillToCast;
      if (player.currentHp < (player.baseHp * 0.4) &&
          readyActiveSkills.any((s) => s.id == 'vagabond_emergency_triage')) {
        skillToCast = readyActiveSkills.firstWhere((s) => s.id == 'vagabond_emergency_triage');
      } else {
        skillToCast = readyActiveSkills.last;
      }

      final success = await castSkill(skillToCast, targetMob: targetMob);
      if (success) return;
    }

    // Fallback to standard weapon attack
    await attackMob(targetMob);
  }

  /// Manually or automatically casts an unlocked active skill
  Future<bool> castSkill(ClassSkill skill, {MobData? targetMob}) async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null || player.currentHp <= 0) return false;

    final logNotifier = _ref.read(combatLogProvider.notifier);
    final currentResource = _ref.read(playerResourceProvider);
    final (resLabel, _, _, _) = PlayerResourceNotifier.getResourceInfo(player, currentResource);

    // 1. Validation
    if (player.level < skill.requiredLevel) {
      logNotifier.addLog('⚠️ ${skill.name} requires Level ${skill.requiredLevel}!');
      return false;
    }

    final currentCooldown = _ref.read(skillCooldownsProvider.notifier).getCooldown(skill.id);
    if (currentCooldown > 0) {
      logNotifier.addLog('⏳ ${skill.name} is on cooldown (${currentCooldown}s remaining)!');
      return false;
    }

    if (skill.numericCost > currentResource) {
      logNotifier.addLog('⚠️ Insufficient $resLabel! Requires ${skill.numericCost} $resLabel (Current: $currentResource).');
      return false;
    }

    // 2. Consume Resource & Trigger Cooldown
    _ref.read(playerResourceProvider.notifier).consume(skill.numericCost);
    _ref.read(skillCooldownsProvider.notifier).triggerCooldown(skill.id, skill.cooldownSeconds);

    // 3. Resolve skill effect
    final roomMobs = (_ref.read(currentRoomMobsProvider).value ?? []).where((m) => m.isAlive).toList();
    final target = targetMob ?? (roomMobs.isNotEmpty ? roomMobs.first : null);

    HapticFeedback.heavyImpact();

    switch (skill.id) {
      // ── Vagabond Skills ──
      case 'vagabond_emergency_triage':
        final healAmount = 25;
        final newHp = min(player.baseHp, player.currentHp + healAmount);
        final actualHealed = newHp - player.currentHp;
        await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
          PlayersCompanion(currentHp: Value(newHp)),
        );
        _ref.read(activeBuffsProvider.notifier).addBuff('🩹 TRIAGE', 4);
        logNotifier.addLog('✨ [EMERGENCY TRIAGE]: Wound bound! Restored +$actualHealed HP ($newHp/${player.baseHp})!');
        return true;

      case 'vagabond_makeshift_shiv':
        if (target == null) {
          logNotifier.addLog('⚠️ No target hostile to strike!');
          return false;
        }
        final dmg = (player.strength * 2.2 + 18).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('🗡️ SERRATED', 3);
        logNotifier.addLog('⚡ [MAKESHIFT SHIV]: Pierced ${target.name}\'s armor for $dmg piercing damage!');
        await _applySkillDamageToMob(target, dmg);
        return true;

      case 'vagabond_improvised_trap':
        if (target == null) {
          logNotifier.addLog('⚠️ No target hostile to trap!');
          return false;
        }
        _ref.read(activeBuffsProvider.notifier).addBuff('🪤 TRAP RIGGED', 5);
        logNotifier.addLog('🪤 [IMPROVISED TRAP]: Detonated trap under ${target.name}! Stunned & dealt 80 Bleed DMG!');
        await _applySkillDamageToMob(target, 80);
        return true;

      // ── Juggernaut Skills ──
      case 'juggernaut_brutal_cleave':
        if (target == null) {
          logNotifier.addLog('⚠️ No target hostile to cleave!');
          return false;
        }
        final baseDmg = (player.strength * 2.0 + 15).toInt();
        logNotifier.addLog('🪓 [BRUTAL CLEAVE]: Cleaved primary target ${target.name} for $baseDmg DMG!');
        await _applySkillDamageToMob(target, baseDmg);

        // Cleave splash across all other living room hostiles
        for (final m in roomMobs.where((m) => m.id != target.id)) {
          final splash = (baseDmg * 0.5).toInt();
          logNotifier.addLog('💥 Cleave swept through ${m.name} (-$splash HP)!');
          await _applySkillDamageToMob(m, splash, skipRetaliationCheck: true);
        }
        return true;

      case 'juggernaut_war_cry':
        _ref.read(activeBuffsProvider.notifier).addBuff('📢 WAR CRY', 6);
        logNotifier.addLog('📢 [WAR CRY]: Deafening bellow shook the chamber! Enemy attack power weakened by 20%!');
        return true;

      case 'juggernaut_ground_slam':
        final slamDmg = (player.strength * 2.5 + 25).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('💥 QUAKE', 4);
        logNotifier.addLog('💥 [GROUND SLAM]: Earth tremor cracked the stone floor! Shockwave tore through all hostiles for $slamDmg DMG!');
        for (final m in List<MobData>.from(roomMobs)) {
          await _applySkillDamageToMob(m, slamDmg, skipRetaliationCheck: true);
        }
        return true;

      case 'juggernaut_colossus_avatar':
        _ref.read(activeBuffsProvider.notifier).addBuff('🛡️ COLOSSUS', 8);
        logNotifier.addLog('🛡️ [COLOSSUS AVATAR]: Unyielding Iron Form unleashed! 40% DMG reduction active for 8 seconds!');
        return true;

      // ── Phantom Skills ──
      case 'phantom_shadow_strike':
        if (target == null) {
          logNotifier.addLog('⚠️ No target in sight to strike!');
          return false;
        }
        final strikeDmg = (player.strength * 2.6 + 22).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('⚡ SHADOWSTEP', 3);
        logNotifier.addLog('⚡ [SHADOW STRIKE]: Phased through the void behind ${target.name}! Critical puncture for $strikeDmg DMG!');
        await _applySkillDamageToMob(target, strikeDmg);
        return true;

      case 'phantom_smoke_screen':
        _ref.read(activeBuffsProvider.notifier).addBuff('💨 SMOKE SCREEN', 5);
        logNotifier.addLog('💨 [SMOKE SCREEN]: Alchemical fog released! Broke enemy line of sight! Next strike guaranteed critical!');
        return true;

      case 'phantom_flurry_of_blades':
        if (target == null) return false;
        final totalDmg = (player.strength * 3.4 + 30).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('⚔️ FLURRY', 3);
        logNotifier.addLog('⚔️ [FLURRY OF BLADES]: 4 lightning-fast slashes shredded ${target.name} for $totalDmg total DMG!');
        await _applySkillDamageToMob(target, totalDmg);
        return true;

      case 'phantom_void_execution':
        if (target == null) return false;
        final isLow = target.currentHp <= (target.maxHp * 0.25);
        final execDmg = isLow ? (target.currentHp + 50) : (player.strength * 4.2 + 50).toInt();
        logNotifier.addLog('☠️ [VOID EXECUTION]: Void rift collapsed within ${target.name}! Dealt $execDmg annihilating DMG!');
        await _applySkillDamageToMob(target, execDmg);
        return true;

      // ── Weaver Skills ──
      case 'weaver_arcane_missile':
        if (target == null) return false;
        final missileDmg = (player.intelligence * 2.8 + 16).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('🔮 AETHERIC', 3);
        logNotifier.addLog('🔮 [ARCANE MISSILE]: Homing darts slammed into ${target.name} for $missileDmg Aetheric DMG!');
        await _applySkillDamageToMob(target, missileDmg);
        return true;

      case 'weaver_frost_nova':
        final frostDmg = (player.intelligence * 2.0 + 14).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('❄️ FROST WARD', 5);
        logNotifier.addLog('❄️ [FROST NOVA]: Ring of biting rime expanded! Dealt $frostDmg Ice DMG and slowed enemy movement!');
        for (final m in List<MobData>.from(roomMobs)) {
          await _applySkillDamageToMob(m, frostDmg, skipRetaliationCheck: true);
        }
        return true;

      case 'weaver_chain_lightning':
        final arcDmg = (player.intelligence * 3.0 + 20).toInt();
        logNotifier.addLog('⚡ [CHAIN LIGHTNING]: High-voltage electrostatic arc discharged for $arcDmg DMG!');
        for (final m in roomMobs.take(3)) {
          await _applySkillDamageToMob(m, arcDmg, skipRetaliationCheck: true);
        }
        return true;

      case 'weaver_astral_cataclysm':
        final cataDmg = (player.intelligence * 4.5 + 40).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('🌠 CATACLYSM', 5);
        logNotifier.addLog('🌠 [ASTRAL CATACLYSM]: Cosmic starlight cascaded from the heavens! $cataDmg DMG to all adversaries!');
        for (final m in List<MobData>.from(roomMobs)) {
          await _applySkillDamageToMob(m, cataDmg, skipRetaliationCheck: true);
        }
        return true;

      // ── Warden Skills ──
      case 'warden_feral_command':
        if (target == null) return false;
        final feralDmg = (player.strength * 2.0 + 16).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('🐺 FERAL HUNTER', 3);
        logNotifier.addLog('🐺 [FERAL COMMAND]: Companion lunged at ${target.name}\'s throat for $feralDmg DMG!');
        await _applySkillDamageToMob(target, feralDmg);
        return true;

      case 'warden_entangling_roots':
        if (target == null) return false;
        final rootDmg = (player.strength * 1.8 + 20).toInt();
        _ref.read(activeBuffsProvider.notifier).addBuff('🌿 ENTANGLED', 4);
        logNotifier.addLog('🌿 [ENTANGLING ROOTS]: Thorny brambles erupted from stone! Immobilized ${target.name} for $rootDmg Nature DMG!');
        await _applySkillDamageToMob(target, rootDmg);
        return true;

      case 'warden_primal_roar':
        _ref.read(activeBuffsProvider.notifier).addBuff('🦁 PRIMAL ROAR', 6);
        logNotifier.addLog('🦁 [PRIMAL ROAR]: Master and companion energized! +35% Attack Speed buff active!');
        return true;

      case 'warden_wrath_of_the_wild':
        _ref.read(activeBuffsProvider.notifier).addBuff('🦖 APEX TITAN', 8);
        logNotifier.addLog('🦖 [WRATH OF THE WILD]: Companion mutated into an Apex Titan! +60% DMG & Cleave active!');
        return true;

      default:
        logNotifier.addLog('✨ Used ${skill.name}!');
        return true;
    }
  }

  /// Internal helper to apply skill damage to a mob and handle defeat / retaliation
  Future<void> _applySkillDamageToMob(MobData mob, int damage, {bool skipRetaliationCheck = false}) async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return;

    final logNotifier = _ref.read(combatLogProvider.notifier);
    final remainingHp = max(0, mob.currentHp - damage);

    if (remainingHp <= 0) {
      await (_db.update(_db.mobs)..where((t) => t.id.equals(mob.id))).write(
        const MobsCompanion(
          currentHp: Value(0),
          isAlive: Value(false),
        ),
      );

      final expGained = mob.expReward;
      final newExp = player.currentExp + expGained;
      final silverDrop = _rng.nextInt(15) + 10;

      logNotifier.addLog('💀 ${mob.name} was slain by your skill! Gained +$expGained EXP & $silverDrop Silver Prisms.');

      if (newExp >= player.maxExp) {
        final newLevel = player.level + 1;
        final nextMaxExp = (player.maxExp * 1.5).toInt();
        await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
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
        await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
          PlayersCompanion(
            currentExp: Value(newExp),
            silverPrisms: Value(player.silverPrisms + silverDrop),
          ),
        );
      }
    } else {
      await (_db.update(_db.mobs)..where((t) => t.id.equals(mob.id))).write(
        MobsCompanion(currentHp: Value(remainingHp)),
      );
    }
  }

  /// Resolves player attack on targetMob, AoE cleave on secondary mobs,
  /// and simultaneous retaliations from all active mobs in the room.
  Future<void> attackMob(MobData targetMob) async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null || player.currentHp <= 0) return;

    final logNotifier = _ref.read(combatLogProvider.notifier);
    final roomMobs = (_ref.read(currentRoomMobsProvider).value ?? []).where((m) => m.isAlive).toList();

    // 1. Fetch equipped player gear (Weapon + Armor)
    final equippedItems = await (_db.select(_db.items)
          ..where((i) => i.ownerId.equals(player.id) & i.isEquipped.equals(true)))
        .get();

    int weaponMin = 6;
    int weaponMax = 12;
    int totalPlayerArmor = player.stamina ~/ 2; // base armor from stamina

    for (final eq in equippedItems) {
      if (eq.baseType == 'Weapon') {
        weaponMin = max(weaponMin, eq.minDamage);
        weaponMax = max(weaponMax, eq.maxDamage);
      }
      totalPlayerArmor += eq.armorValue;
    }

    // Player attack roll on primary target
    final statBonus = (player.strength ~/ 2);
    final dmgRoll = _rng.nextInt(max(1, weaponMax - weaponMin + 1)) + weaponMin + statBonus;
    final isCrit = _rng.nextDouble() < 0.18;
    final finalPlayerDmg = isCrit ? (dmgRoll * 1.8).toInt() : dmgRoll;

    if (isCrit) {
      HapticFeedback.heavyImpact();
      logNotifier.addLog(
          '⚡ CRITICAL STRIKE! You dealt $finalPlayerDmg damage to ${targetMob.name}!');
    } else {
      HapticFeedback.lightImpact();
      logNotifier.addLog('⚔️ You struck ${targetMob.name} for $finalPlayerDmg damage.');
    }

    final remainingTargetHp = max(0, targetMob.currentHp - finalPlayerDmg);

    // 2. Cleave splash damage (40%) to other living mobs in room
    final otherMobs = roomMobs.where((m) => m.id != targetMob.id).toList();
    if (otherMobs.isNotEmpty) {
      final cleaveDmg = max(1, (finalPlayerDmg * 0.40).toInt());
      for (final other in otherMobs) {
        final newOtherHp = max(0, other.currentHp - cleaveDmg);
        await (_db.update(_db.mobs)..where((t) => t.id.equals(other.id))).write(
          MobsCompanion(
            currentHp: Value(newOtherHp),
            isAlive: Value(newOtherHp > 0),
          ),
        );
        logNotifier.addLog('💥 Cleave splash dealt $cleaveDmg damage to ${other.name}!');
        if (newOtherHp <= 0) {
          logNotifier.addLog('💀 ${other.name} fell to the sweeping strike!');
        }
      }
    }

    // 3. Check if primary target is defeated
    if (remainingTargetHp <= 0) {
      await (_db.update(_db.mobs)..where((t) => t.id.equals(targetMob.id))).write(
        const MobsCompanion(
          currentHp: Value(0),
          isAlive: Value(false),
        ),
      );

      final expGained = targetMob.expReward;
      final newExp = player.currentExp + expGained;
      final silverDrop = _rng.nextInt(15) + 10;

      HapticFeedback.mediumImpact();
      logNotifier.addLog(
          '💀 ${targetMob.name} was slain! Gained +$expGained EXP & $silverDrop Silver Prisms.');

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

      // Boss Conquer check
      if (targetMob.name == 'The Hollow Woodsman') {
        final currentActs = player.actsCompleted;
        if (currentActs < 1) {
          await (_db.update(_db.players)..where((t) => t.id.equals(player.id)))
              .write(const PlayersCompanion(actsCompleted: Value(1)));
          logNotifier.addLog(
              '🌀 [SYSTEM MILESTONE]: ACT I CONQUERED! Waypoint to ACT II (The Sunken City) Unlocked!');
        }
      }

      // Roll canonical item drop
      final dropRate = targetMob.isMiniBoss ? 1.0 : 0.50;
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
            isStoredInSafe: const Value(false),
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
    } else {
      await (_db.update(_db.mobs)..where((t) => t.id.equals(targetMob.id))).write(
        MobsCompanion(currentHp: Value(remainingTargetHp)),
      );
    }

    // 4. Simultaneous Retaliation: All surviving mobs strike back together!
    // But retaliation is mitigated by player armor and capped so swarms can't instantly kill.
    final survivingMobs = (await (_db.select(_db.mobs)
          ..where((t) => t.roomId.equals(player.currentRoomId) & t.isAlive.equals(true)))
        .get());

    if (survivingMobs.isNotEmpty) {
      int rawRetaliationDmg = 0;
      final List<String> strikeLogs = [];

      for (final m in survivingMobs) {
        final mobDmg = _rng.nextInt(m.maxDamage - m.minDamage + 1) + m.minDamage;
        rawRetaliationDmg += mobDmg;
        strikeLogs.add('${m.name} (-$mobDmg)');
      }

      // Apply player armor mitigation: each point of armor reduces damage by ~1.5
      // (minimum 1 damage always gets through per surviving mob)
      final armorMitigation = min(rawRetaliationDmg - survivingMobs.length, totalPlayerArmor * 3 ~/ 2);
      int mitigatedDmg = max(survivingMobs.length, rawRetaliationDmg - armorMitigation);

      // Soft cap: swarm can never deal more than 45% of player max HP in a single retaliation
      final swarmCap = (player.baseHp * 0.45).toInt();
      mitigatedDmg = min(mitigatedDmg, swarmCap);

      final remainingPlayerHp = max(0, player.currentHp - mitigatedDmg);
      final armorNote = armorMitigation > 0 ? ' ($armorMitigation blocked by armor)' : '';
      logNotifier.addLog('💥 Swarm Strikes: ${strikeLogs.join(', ')} | Raw -$rawRetaliationDmg$armorNote → -$mitigatedDmg HP ($remainingPlayerHp HP left)');

      if (remainingPlayerHp <= 0) {
        await _handlePlayerDeath(player.currentRoomId);
        return;
      } else {
        await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
          PlayersCompanion(currentHp: Value(remainingPlayerHp)),
        );
      }
    }
  }

  /// Triggered upon entering a room: aggressive mobs ambush the player immediately!
  /// De-escalates to neutral if player level is 5x or more of the mob's level.
  Future<void> checkRoomAggroAmbush(int roomId) async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null || player.currentHp <= 0) return;

    final logNotifier = _ref.read(combatLogProvider.notifier);
    final roomMobs = await (_db.select(_db.mobs)
          ..where((t) => t.roomId.equals(roomId) & t.isAlive.equals(true)))
        .get();

    if (roomMobs.isEmpty) return;

    // Filter aggressive mobs that the player has NOT yet out-leveled by 5x
    final aggressiveAmbushers = roomMobs.where((m) {
      if (!m.isAggro) return false;
      // If player level is >= 5 times mob level, mob is pacified and will not ambush!
      final isPacified = player.level >= (m.level * 5);
      return !isPacified;
    }).toList();

    if (aggressiveAmbushers.isEmpty) {
      // Mobs are either neutral or pacified
      logNotifier.addLog('🛡️ Sector hostiles are pacified / neutral. You pass through unhindered.');
      return;
    }

    HapticFeedback.heavyImpact();
    int rawAmbushDmg = 0;
    final List<String> names = [];

    // Gather player armor for ambush mitigation (base from stamina, no gear query needed here)
    final playerAmbushArmor = player.stamina ~/ 2;

    for (final ambusher in aggressiveAmbushers) {
      names.add(ambusher.name);
      final strike = _rng.nextInt(ambusher.maxDamage - ambusher.minDamage + 1) + ambusher.minDamage;
      rawAmbushDmg += strike;
    }

    // Ambush is mitigated by player's base armor and capped at 30% of max HP
    final ambushMitigation = min(rawAmbushDmg - aggressiveAmbushers.length, playerAmbushArmor * 2);
    int finalAmbushDmg = max(aggressiveAmbushers.length, rawAmbushDmg - ambushMitigation);
    final ambushCap = (player.baseHp * 0.30).toInt();
    finalAmbushDmg = min(finalAmbushDmg, ambushCap);

    final remainingHp = max(0, player.currentHp - finalAmbushDmg);
    logNotifier.addLog('⚠️ [AMBUSH!]: ${names.join(', ')} pounced! Dealt -$finalAmbushDmg damage! ($remainingHp HP left)');
    logNotifier.addLog('⚡ Tap [FLEE] to retreat or engage hostiles!');

    if (remainingHp <= 0) {
      await _handlePlayerDeath(roomId);
    } else {
      await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
        PlayersCompanion(currentHp: Value(remainingHp)),
      );
    }
  }

  /// Handles player death: Drops unequipped bag items at death location, marks map,
  /// preserves town safe items and prisms, respawns player at sanctuary with 100% HP.
  Future<void> _handlePlayerDeath(int deathRoomId) async {
    stopAutoAttack();
    HapticFeedback.heavyImpact();

    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return;

    final logNotifier = _ref.read(combatLogProvider.notifier);

    // 1. Drop all unequipped bag items to ground in deathRoomId
    // (Equipped gear and items in the safe remain intact!)
    await (_db.update(_db.items)
          ..where((i) =>
              i.ownerId.equals(player.id) &
              i.isEquipped.equals(false) &
              i.isStoredInSafe.equals(false)))
        .write(
      ItemsCompanion(
        ownerId: const Value(null),
        groundRoomId: Value(deathRoomId),
      ),
    );

    // 2. Determine sanctuary respawn checkpoint
    // If Act 1 Vanguard's Hold (Room 302) is reached, respawn at 302, otherwise Room 101
    final vanguardRoom = await (_db.select(_db.rooms)..where((t) => t.id.equals(302))).getSingleOrNull();
    final bool hasVanguard = vanguardRoom?.isExplored == true;
    final respawnRoomId = hasVanguard ? 302 : 101;

    // 3. Restore player HP and save lastDeathRoomId
    await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
      PlayersCompanion(
        currentHp: Value(player.baseHp),
        currentRoomId: Value(respawnRoomId),
        lastDeathRoomId: Value(deathRoomId),
      ),
    );

    logNotifier.addLog('💀 [FATAL OVERRIDE]: Soul Tether severed at Node $deathRoomId!');
    logNotifier.addLog('🎒 Satchel dropped! Marked with [💀 LOST SATCHEL] on Cartography Map.');
    logNotifier.addLog('✨ Reconstructed at Sanctuary checkpoint (Node $respawnRoomId) with full HP.');
    logNotifier.addLog('🔒 Items stored in Town Safe remained 100% secure.');
  }

  /// Recovers all dropped ground items in the current room into the player's bag.
  Future<int> recoverDroppedSatchel(int roomId) async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return 0;

    final groundItems = await (_db.select(_db.items)
          ..where((i) => i.groundRoomId.equals(roomId) & i.ownerId.isNull()))
        .get();

    if (groundItems.isEmpty) return 0;

    HapticFeedback.mediumImpact();

    await (_db.update(_db.items)
          ..where((i) => i.groundRoomId.equals(roomId) & i.ownerId.isNull()))
        .write(
      ItemsCompanion(
        ownerId: Value(player.id),
        groundRoomId: const Value(null),
        isStoredInSafe: const Value(false),
      ),
    );

    // If this was the last death room, clear the death marker on map
    if (player.lastDeathRoomId == roomId) {
      await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
        const PlayersCompanion(
          lastDeathRoomId: Value(null),
        ),
      );
    }

    final count = groundItems.length;
    _ref.read(combatLogProvider.notifier).addLog(
        '🎒 [SATCHEL RECOVERED]: Retrieved $count dropped items from the Void floor!');
    return count;
  }

  /// Tactical retreat from an encounter
  Future<bool> fleeCombat(MobData mob) async {
    stopAutoAttack();

    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return false;

    final currentRoom = _ref.read(currentRoomStreamProvider).value;
    if (currentRoom == null) return false;

    final logNotifier = _ref.read(combatLogProvider.notifier);

    // Find an escape route
    final escapeRoomId = currentRoom.southExitId ??
        currentRoom.westExitId ??
        currentRoom.northExitId ??
        currentRoom.eastExitId;

    if (escapeRoomId == null) {
      logNotifier.addLog('⚠️ No escape route available! You are cornered!');
      return false;
    }

    final fleeChance = 0.85;
    final success = _rng.nextDouble() < fleeChance;

    if (success) {
      HapticFeedback.selectionClick();
      await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
        PlayersCompanion(currentRoomId: Value(escapeRoomId)),
      );
      await (_db.update(_db.rooms)..where((t) => t.id.equals(escapeRoomId))).write(
        const RoomsCompanion(isExplored: Value(true)),
      );

      logNotifier.addLog(
          '🏃 [TACTICAL RETREAT]: You broke combat engagement and fled safely to Node $escapeRoomId!');
      return true;
    } else {
      HapticFeedback.heavyImpact();
      final scrapeDmg = 2 + (mob.level);
      final remainingHp = max(1, player.currentHp - scrapeDmg);
      await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
        PlayersCompanion(currentHp: Value(remainingHp)),
      );
      logNotifier.addLog(
          '⚠️ Escape hindered! ${mob.name} struck you for $scrapeDmg as you retreated!');
      return false;
    }
  }

  /// Rest and recover HP when no active hostile enemies are engaging the player
  Future<bool> restToRecover() async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return false;

    final logNotifier = _ref.read(combatLogProvider.notifier);
    final roomMobs = (_ref.read(currentRoomMobsProvider).value ?? []).where((m) => m.isAlive).toList();

    // Check if room has active aggro enemies
    final activeHostiles = roomMobs.where((m) {
      if (!m.isAggro) return false;
      final isPacified = player.level >= (m.level * 5);
      return !isPacified;
    }).toList();

    if (activeHostiles.isNotEmpty) {
      HapticFeedback.heavyImpact();
      logNotifier.addLog('⚠️ Cannot rest here! Active threats (${activeHostiles.map((m) => m.name).join(', ')}) are prowling the sector!');
      return false;
    }

    if (player.currentHp >= player.baseHp) {
      logNotifier.addLog('✨ Vitality already at peak (HP ${player.currentHp}/${player.baseHp}). No rest needed.');
      return false;
    }

    HapticFeedback.mediumImpact();
    // Rest heals 35% of max HP or minimum 25 HP
    final healAmount = max(25, (player.baseHp * 0.35).toInt());
    final newHp = min(player.baseHp, player.currentHp + healAmount);
    final actualHealed = newHp - player.currentHp;

    await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
      PlayersCompanion(currentHp: Value(newHp)),
    );

    logNotifier.addLog('🏕️ [REST COMPLETED]: Caught your breath and tended wounds. Restored +$actualHealed HP ($newHp/${player.baseHp})!');
    return true;
  }

  /// Quick drink best available potion from bag
  Future<String> quickDrinkPotion() async {
    final player = _ref.read(playerStreamProvider).value;
    if (player == null) return 'No active player.';

    final logNotifier = _ref.read(combatLogProvider.notifier);

    final potions = await (_db.select(_db.items)
          ..where((i) =>
              i.ownerId.equals(player.id) &
              i.isStoredInSafe.equals(false) &
              (i.baseType.equals('Potion') | i.baseType.equals('Consumable'))))
        .get();

    if (potions.isEmpty) {
      HapticFeedback.heavyImpact();
      final msg = '⚠️ No restorative potions in satchel! Visit town or check bag.';
      logNotifier.addLog(msg);
      return msg;
    }

    // Pick first potion
    final potion = potions.first;
    int healAmount = 35;
    try {
      if (potion.modifiersJson.trim().isNotEmpty) {
        final decoded = jsonDecode(potion.modifiersJson);
        if (decoded is Map<String, dynamic> && decoded['healAmount'] != null) {
          healAmount = (decoded['healAmount'] as num).toInt();
        }
      }
    } catch (_) {}

    final newHp = min(player.baseHp, player.currentHp + healAmount);
    final actualHealed = newHp - player.currentHp;

    await (_db.update(_db.players)..where((t) => t.id.equals(player.id))).write(
      PlayersCompanion(currentHp: Value(newHp)),
    );
    await (_db.delete(_db.items)..where((i) => i.id.equals(potion.id))).go();

    HapticFeedback.selectionClick();
    final log = '🧪 [POTION QUENCHED]: Drank ${potion.name}! Restored +$actualHealed HP ($newHp/${player.baseHp})!';
    logNotifier.addLog(log);
    return log;
  }
}
