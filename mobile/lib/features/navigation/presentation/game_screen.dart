import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';
import 'package:vagabond_hero/features/combat/domain/combat_engine.dart';
import 'package:vagabond_hero/features/inventory/presentation/inventory_screen.dart';
import 'package:vagabond_hero/features/minimap/presentation/minimap_widget.dart';
import 'package:vagabond_hero/features/navigation/domain/navigation_controller.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final nav = ref.read(navigationControllerProvider);
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.keyW || key == LogicalKeyboardKey.arrowUp) {
      nav.moveTo(Direction.north);
    } else if (key == LogicalKeyboardKey.keyS || key == LogicalKeyboardKey.arrowDown) {
      nav.moveTo(Direction.south);
    } else if (key == LogicalKeyboardKey.keyA || key == LogicalKeyboardKey.arrowLeft) {
      nav.moveTo(Direction.west);
    } else if (key == LogicalKeyboardKey.keyD || key == LogicalKeyboardKey.arrowRight) {
      nav.moveTo(Direction.east);
    } else if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.digit1) {
      final mobs = ref.read(currentRoomMobsProvider).value ?? [];
      if (mobs.isNotEmpty) {
        ref.read(combatEngineProvider).attackMob(mobs.first);
      }
    } else if (key == LogicalKeyboardKey.keyI) {
      _showInventoryModal(context, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerAsync = ref.watch(playerStreamProvider);
    final roomAsync = ref.watch(currentRoomStreamProvider);
    final mobsAsync = ref.watch(currentRoomMobsProvider);
    final combatLogs = ref.watch(combatLogProvider);

    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: GameColors.bgPrimary,
        appBar: AppBar(
          backgroundColor: GameColors.bgSecondary,
          elevation: 0,
          titleSpacing: 12,
          title: Text(
            'VAGABOND HERO',
            style: GoogleFonts.cinzel(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          actions: [
            playerAsync.when(
              data: (player) => player == null
                  ? const SizedBox()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () => _showStatusModal(context, ref),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Lv.${player.level}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: GameColors.goldAccent,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'HP ${player.currentHp}/${player.baseHp}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10.5,
                                    color: player.currentHp < (player.baseHp * 0.3)
                                        ? GameColors.crimsonBlood
                                        : GameColors.terminalGreen,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                // Dynamic Secondary Resource (Grit, Fury, Energy, Mana, Animus)
                                () {
                                  final (resLabel, resVal, resMax, resColor) = switch (player.jobClass) {
                                    'Juggernaut' || 'Berserker' || 'Void-Knight' => (
                                        'FURY',
                                        25,
                                        100,
                                        const Color(0xFFEF4444)
                                      ),
                                    'Phantom' || 'Assassin' || 'Rift-Sniper' => (
                                        'NRG',
                                        80,
                                        100,
                                        const Color(0xFFF59E0B)
                                      ),
                                    'Weaver' || 'Elementalist' || 'Blood Mage' => (
                                        'MP',
                                        (50 + player.intelligence * 5),
                                        (50 + player.intelligence * 5),
                                        const Color(0xFF38BDF8)
                                      ),
                                    'Warden' || 'Necromancer' || 'Druid' => (
                                        'ANM',
                                        45,
                                        100,
                                        const Color(0xFF10B981)
                                      ),
                                    _ => ('GRIT', 60, 100, const Color(0xFFB45309)),
                                  };
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: resColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: resColor.withValues(alpha: 0.5), width: 0.6),
                                    ),
                                    child: Text(
                                      '$resLabel $resVal/$resMax',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: resColor,
                                      ),
                                    ),
                                  );
                                }(),
                                const SizedBox(width: 5),
                                Text(
                                  '💎${player.silverPrisms}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10.5,
                                    color: GameColors.cyanRune,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.backpack_outlined,
                              size: 19, color: GameColors.cyanRune),
                          tooltip: 'Inventory',
                          onPressed: () => _showInventoryModal(context, ref),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
              loading: () => const SizedBox(),
              error: (_, _) => const SizedBox(),
            ),
          ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: GameColors.borderSubtle, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Room Lore & Status
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: GameColors.bgSecondary,
                  border: Border(
                    bottom: BorderSide(color: GameColors.borderSubtle),
                  ),
                ),
                child: roomAsync.when(
                  data: (room) {
                    if (room == null) {
                      return const Center(child: Text('Traversing the void...'));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'NODE ${room.id} // ACT ${room.act}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: GameColors.cyanRune,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'EXPLORED',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: GameColors.terminalGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          room.title,
                          style: GoogleFonts.cinzel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              room.description,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                height: 1.6,
                                color: GameColors.textMain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: GameColors.cyanRune),
                  ),
                  error: (e, _) => Center(child: Text('Error loading room: $e')),
                ),
              ),
            ),

            // Middle Section: Combat & Events / Mobs
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: GameColors.bgSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOSTILES & ENTITIES',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: GameColors.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: mobsAsync.when(
                        data: (mobs) {
                          if (mobs.isEmpty) {
                            return Center(
                              child: Text(
                                'No hostiles detected in this sector.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: GameColors.textDim,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: mobs.length,
                            itemBuilder: (context, index) {
                              final mob = mobs[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: GameColors.bgCard,
                                  border: Border.all(
                                    color: GameColors.crimsonBlood.withValues(alpha: 0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded,
                                        color: GameColors.crimsonBlood, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${mob.name} (Lv.${mob.level})',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'HP: ${mob.currentHp}/${mob.maxHp}',
                                            style: GoogleFonts.jetBrainsMono(
                                              fontSize: 11,
                                              color: GameColors.crimsonBlood,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: GameColors.crimsonBlood,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(combatEngineProvider)
                                            .attackMob(mob);
                                      },
                                      child: Text(
                                        'Attack',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const SizedBox(),
                        error: (_, _) => const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Log Console Section
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black,
              child: ListView.builder(
                reverse: true,
                itemCount: combatLogs.length,
                itemBuilder: (context, index) {
                  final log = combatLogs.reversed.toList()[index];
                  Color logColor = GameColors.textMuted;
                  if (log.contains('CRITICAL') || log.contains('slain')) {
                    logColor = GameColors.terminalGreen;
                  } else if (log.contains('retaliates') || log.contains('struck')) {
                    logColor = GameColors.goldAccent;
                  } else if (log.contains('LEVEL UP')) {
                    logColor = GameColors.cyanRune;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: Text(
                      log,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: logColor,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Control Bar: D-Pad + Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: GameColors.bgSecondary,
                border: Border(
                  top: BorderSide(color: GameColors.borderSubtle),
                ),
              ),
              child: roomAsync.when(
                data: (room) {
                  if (room == null) return const SizedBox();
                  final nav = ref.read(navigationControllerProvider);
                  return Row(
                    children: [
                      // ── D-Pad ──────────────────────────────
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // North
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: _DPadButton(
                                  icon: Icons.keyboard_arrow_up,
                                  enabled: room.northExitId != null,
                                  tooltip: 'North',
                                  onPressed: () => nav.moveTo(Direction.north),
                                ),
                              ),
                            ),
                            // South
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: _DPadButton(
                                  icon: Icons.keyboard_arrow_down,
                                  enabled: room.southExitId != null,
                                  tooltip: 'South',
                                  onPressed: () => nav.moveTo(Direction.south),
                                ),
                              ),
                            ),
                            // West
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: _DPadButton(
                                  icon: Icons.keyboard_arrow_left,
                                  enabled: room.westExitId != null,
                                  tooltip: 'West',
                                  onPressed: () => nav.moveTo(Direction.west),
                                ),
                              ),
                            ),
                            // East
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: _DPadButton(
                                  icon: Icons.keyboard_arrow_right,
                                  enabled: room.eastExitId != null,
                                  tooltip: 'East',
                                  onPressed: () => nav.moveTo(Direction.east),
                                ),
                              ),
                            ),
                            // Centre dot
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: GameColors.borderSubtle,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // ── Action Buttons ──────────────────────
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Attack nearest mob
                          _ActionButton(
                            icon: Icons.gps_fixed,
                            label: 'ATK',
                            color: GameColors.crimsonBlood,
                            tooltip: 'Attack nearest mob [Space]',
                            onPressed: () {
                              final mobs = ref.read(currentRoomMobsProvider).value ?? [];
                              if (mobs.isNotEmpty) {
                                ref.read(combatEngineProvider).attackMob(mobs.first);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          // Inventory
                          _ActionButton(
                            icon: Icons.backpack_outlined,
                            label: 'BAG',
                            color: GameColors.cyanRune,
                            tooltip: 'Inventory [I]',
                            onPressed: () => _showInventoryModal(context, ref),
                          ),
                          const SizedBox(height: 8),
                          // Player status sheet
                          _ActionButton(
                            icon: Icons.person_outline,
                            label: 'STAT',
                            color: GameColors.goldAccent,
                            tooltip: 'Character Status',
                            onPressed: () => _showStatusModal(context, ref),
                          ),
                          const SizedBox(height: 8),
                          // World map
                          _ActionButton(
                            icon: Icons.map_outlined,
                            label: 'MAP',
                            color: const Color(0xFF8B5CF6),
                            tooltip: 'World Map',
                            onPressed: () => _showMapModal(context, ref),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(),
                error: (_, _) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

// ─── D-Pad arrow button ───────────────────────────────────────────────────────
class _DPadButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final String tooltip;
  final VoidCallback onPressed;

  const _DPadButton({
    required this.icon,
    required this.enabled,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? GameColors.cyanRune : GameColors.textDim;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        splashColor: GameColors.cyanRune.withValues(alpha: 0.2),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: enabled
                ? GameColors.cyanRune.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled ? GameColors.cyanDim : GameColors.borderSubtle,
              width: 1,
            ),
          ),
          child: Icon(icon, size: 22, color: color),
        ),
      ),
    );
  }
}

// ─── Sidebar action button ────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 56,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 3),
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showInventoryModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: GameColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      side: BorderSide(color: GameColors.borderSubtle),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return const InventoryScreen();
        },
      );
    },
  );
}

// ─── Character Status Modal ───────────────────────────────────────────────────
void _showStatusModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: GameColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      side: BorderSide(color: GameColors.borderSubtle),
    ),
    builder: (context) {
      return Consumer(
        builder: (context, sheetRef, _) {
          final playerAsync = sheetRef.watch(playerStreamProvider);
          final itemsAsync = sheetRef.watch(playerInventoryProvider);

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollCtrl) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Handle
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: GameColors.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle,
                              color: GameColors.goldAccent, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'CHARACTER DOSSIER',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: GameColors.textMuted, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: GameColors.borderSubtle, height: 1),

                    // Content
                    Expanded(
                      child: playerAsync.when(
                        data: (player) {
                          if (player == null) {
                            return const Center(child: Text('No player data.'));
                          }

                          return itemsAsync.when(
                            data: (items) {
                              final equippedItems = items.where((i) => i.isEquipped).toList();

                              // Aggregate gear stats
                              int gearMinDmg = 0;
                              int gearMaxDmg = 0;
                              int gearArmor = 0;
                              int bonusStr = 0;
                              int bonusAgi = 0;
                              int bonusInt = 0;
                              int bonusSta = 0;
                              int bonusVit = 0;
                              
                              // Elemental damage bonuses
                              int fireDmg = 0;
                              int iceDmg = 0;
                              int poisonDmg = 0;
                              int voidDmg = 0;
                              int lightningDmg = 0;

                              // Resistances
                              int fireResist = 0;
                              int iceResist = 0;
                              int poisonResist = 0;
                              int voidResist = 0;
                              int lightningResist = 0;
                              int waterResist = 0;
                              int allResist = 0;

                              // Utility & Combat Modifiers
                              int lifeSteal = 0;
                              int damageReflect = 0;
                              int magicFind = 0;
                              int goldDropRate = 0;
                              int expGained = 0;
                              int bossDamage = 0;
                              int cooldownReduction = 0;
                              int attackSpeed = 0;
                              int castSpeed = 0;

                              final specialBuffs = <String>[];

                              // Helper to parse percentages/values from modifier strings
                              int parseVal(String str) {
                                final match = RegExp(r'([+-]?\d+)').firstMatch(str);
                                return match != null ? int.tryParse(match.group(1) ?? '0') ?? 0 : 0;
                              }

                              for (final item in equippedItems) {
                                gearMinDmg += item.minDamage;
                                gearMaxDmg += item.maxDamage;
                                gearArmor += item.armorValue;

                                if (item.modifiersJson.trim().isNotEmpty) {
                                  try {
                                    final decoded = jsonDecode(item.modifiersJson);
                                    if (decoded is Map<String, dynamic>) {
                                      final bs = decoded['baseStats'] as Map<String, dynamic>?;
                                      if (bs != null) {
                                        bonusStr += (bs['STR'] as num?)?.toInt() ?? 0;
                                        bonusAgi += (bs['AGI'] as num?)?.toInt() ?? 0;
                                        bonusInt += (bs['INT'] as num?)?.toInt() ?? 0;
                                        bonusSta += (bs['STA'] as num?)?.toInt() ?? 0;
                                        bonusVit += (bs['VIT'] as num?)?.toInt() ?? 0;
                                      }

                                      final allTextMods = <String>[];
                                      final bList = decoded['buffs'] as List<dynamic>?;
                                      if (bList != null) allTextMods.addAll(bList.map((e) => e.toString()));
                                      final rolls = decoded['statRolls'] as List<dynamic>?;
                                      if (rolls != null) allTextMods.addAll(rolls.map((e) => e.toString()));
                                      final others = decoded['otherModifiers'] as List<dynamic>?;
                                      if (others != null) allTextMods.addAll(others.map((e) => e.toString()));

                                      for (final mod in allTextMods) {
                                        specialBuffs.add(mod);
                                        final lower = mod.toLowerCase();
                                        final val = parseVal(mod);

                                        if (lower.contains('all resist')) {
                                          allResist += val;
                                        } else if (lower.contains('fire resist')) {
                                          fireResist += val;
                                        } else if (lower.contains('ice resist') || lower.contains('cold resist')) {
                                          iceResist += val;
                                        } else if (lower.contains('poison resist')) {
                                          poisonResist += val;
                                        } else if (lower.contains('void resist')) {
                                          voidResist += val;
                                        } else if (lower.contains('lightning resist')) {
                                          lightningResist += val;
                                        } else if (lower.contains('water resist')) {
                                          waterResist += val;
                                        }

                                        if (lower.contains('fire damage')) fireDmg += val;
                                        if (lower.contains('ice damage') || lower.contains('cold damage')) iceDmg += val;
                                        if (lower.contains('poison damage')) poisonDmg += val;
                                        if (lower.contains('void damage') || lower.contains('shadow damage')) voidDmg += val;
                                        if (lower.contains('lightning damage')) lightningDmg += val;

                                        if (lower.contains('life-steal') || lower.contains('life steal')) lifeSteal += val;
                                        if (lower.contains('reflect') || lower.contains('thorns')) damageReflect += val;
                                        if (lower.contains('magic find')) magicFind += val;
                                        if (lower.contains('gold drop') || lower.contains('gold rate')) goldDropRate += val;
                                        if (lower.contains('exp gain') || lower.contains('exp rate')) expGained += val;
                                        if (lower.contains('boss damage')) bossDamage += val;
                                        if (lower.contains('cooldown')) cooldownReduction += val;
                                        if (lower.contains('attack speed')) attackSpeed += val;
                                        if (lower.contains('cast speed')) castSpeed += val;
                                      }

                                      final ut = decoded['uniqueTrait'] as String?;
                                      if (ut != null && ut.isNotEmpty) {
                                        specialBuffs.add('★ $ut');
                                      }
                                    }
                                  } catch (_) {}
                                }
                              }

                              final totalStr = player.strength + bonusStr;
                              final totalAgi = player.agility + bonusAgi;
                              final totalInt = player.intelligence + bonusInt;
                              final totalSta = player.stamina + bonusSta;
                              // Stamina provides +10 Max HP per point (plus legacy VIT*5 if present)
                              final effectiveMaxHp = player.baseHp + (totalSta * 10) + (bonusVit * 5);
                              // Stamina provides +1 Armor per 4 points
                              final totalArmor = gearArmor + (totalSta ~/ 4);

                              // Combat stats
                              final baseAtkMin = 4 + (totalStr ~/ 3);
                              final baseAtkMax = 8 + (totalStr ~/ 3);
                              final totalMinAtk = baseAtkMin + gearMinDmg;
                              final totalMaxAtk = baseAtkMax + gearMaxDmg;

                              final critChance = (10.0 + (totalAgi * 0.5)).toStringAsFixed(1);
                              final critDmg = (150.0 + (totalAgi * 1.0)).toInt();
                              final evasion = (5.0 + (totalAgi * 0.4)).toStringAsFixed(1);
                              final dmgReduction = totalArmor > 0
                                  ? ((totalArmor / (totalArmor + 50)) * 100).toStringAsFixed(1)
                                  : '0.0';

                              final hpPct = player.currentHp / effectiveMaxHp.clamp(1, 9999);
                              final expPct = player.currentExp / player.maxExp.clamp(1, 999999);

                              return ListView(
                                controller: scrollCtrl,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                children: [
                                  // Identity Hero Card
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.goldAccent.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: GameColors.goldAccent.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: GameColors.goldAccent.withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: GameColors.goldAccent),
                                          ),
                                          child: const Icon(Icons.shield_moon,
                                              size: 24, color: GameColors.goldAccent),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                player.name.toUpperCase(),
                                                style: GoogleFonts.cinzel(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${player.jobClass}  •  Act I Vagabond',
                                                style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 11,
                                                  color: GameColors.goldAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'LEVEL',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 9,
                                                color: GameColors.textMuted,
                                              ),
                                            ),
                                            Text(
                                              '${player.level}',
                                              style: GoogleFonts.cinzel(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: GameColors.cyanRune,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Vitals & Progression Bars (HP, EXP, Currency)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgCard,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GameColors.borderSubtle),
                                    ),
                                    child: Column(
                                      children: [
                                        _DossierBar(
                                          label: 'HEALTH POINTS',
                                          valueText: '${player.currentHp} / $effectiveMaxHp',
                                          fraction: hpPct,
                                          color: hpPct < 0.3
                                              ? GameColors.crimsonBlood
                                              : GameColors.terminalGreen,
                                        ),
                                        const SizedBox(height: 10),
                                        // Dynamic Secondary Resource Bar
                                        () {
                                          final (resLabel, resVal, resMax, resColor, resDesc) = switch (player.jobClass) {
                                            'Juggernaut' || 'Berserker' || 'Void-Knight' => (
                                                'FURY (COMBAT GENERATION)',
                                                25,
                                                100,
                                                const Color(0xFFEF4444),
                                                'Generated on hit/damage taken'
                                              ),
                                            'Phantom' || 'Assassin' || 'Rift-Sniper' => (
                                                'ENERGY (HIGH-SPEED STAMINA)',
                                                80,
                                                100,
                                                const Color(0xFFF59E0B),
                                                '+25 regenerated per turn'
                                              ),
                                            'Weaver' || 'Elementalist' || 'Blood Mage' => (
                                                'MANA (ARCANE RESERVOIR)',
                                                (50 + totalInt * 5),
                                                (50 + totalInt * 5),
                                                const Color(0xFF38BDF8),
                                                'Derived from Intelligence'
                                              ),
                                            'Warden' || 'Necromancer' || 'Druid' => (
                                                'ANIMUS (PACK RESONANCE)',
                                                45,
                                                100,
                                                const Color(0xFF10B981),
                                                'Generated by companion attacks'
                                              ),
                                            _ => (
                                                'GRIT (SURVIVOR WILLPOWER)',
                                                60,
                                                100,
                                                const Color(0xFFB45309),
                                                'Gained during turns & taking hits'
                                              ),
                                          };
                                          final resPct = (resVal / resMax).clamp(0.0, 1.0);
                                          return Column(
                                            children: [
                                              _DossierBar(
                                                label: resLabel,
                                                valueText: '$resVal / $resMax ($resDesc)',
                                                fraction: resPct,
                                                color: resColor,
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          );
                                        }(),
                                        _DossierBar(
                                          label: 'EXPERIENCE PROGRESS',
                                          valueText: '${player.currentExp} / ${player.maxExp} (${(expPct * 100).toStringAsFixed(0)}%)',
                                          fraction: expPct,
                                          color: GameColors.cyanRune,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '💎 SILVER PRISMS',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 11,
                                                color: GameColors.textMuted,
                                              ),
                                            ),
                                            Text(
                                              '${player.silverPrisms}',
                                              style: GoogleFonts.jetBrainsMono(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: GameColors.cyanRune,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Offense Section
                                  _StatsSectionTitle(title: 'COMBAT OFFENSE', icon: Icons.flash_on, color: GameColors.crimsonBlood),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GameColors.borderSubtle),
                                    ),
                                    child: Column(
                                      children: [
                                        _StatDetailRow(
                                          label: 'Total Attack Range',
                                          value: '$totalMinAtk – $totalMaxAtk DMG',
                                          subtext: '(Base: $baseAtkMin–$baseAtkMax, Gear: +$gearMinDmg–$gearMaxDmg)',
                                          color: GameColors.crimsonBlood,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Critical Strike Chance',
                                          value: '$critChance%',
                                          subtext: 'Base 10% + 0.5%/AGI',
                                          color: GameColors.goldAccent,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Critical Damage Multiplier',
                                          value: '$critDmg%',
                                          subtext: 'Base 150% + 1.0%/AGI',
                                          color: GameColors.goldAccent,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Defense Section
                                  _StatsSectionTitle(title: 'DEFENSE & SURVIVAL', icon: Icons.shield, color: GameColors.terminalGreen),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GameColors.borderSubtle),
                                    ),
                                    child: Column(
                                      children: [
                                        _StatDetailRow(
                                          label: 'Total Armor Value',
                                          value: '$totalArmor ARM',
                                          subtext: 'Gear: $gearArmor + Stamina: +${totalSta ~/ 4}',
                                          color: GameColors.terminalGreen,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Physical Damage Mitigation',
                                          value: '$dmgReduction%',
                                          subtext: 'Estimated mitigation formula',
                                          color: GameColors.terminalGreen,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Evasion & Dodge Chance',
                                          value: '$evasion%',
                                          subtext: 'Base 5% + 0.4%/AGI',
                                          color: GameColors.cyanRune,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Attributes Section
                                  _StatsSectionTitle(title: 'CORE ATTRIBUTES', icon: Icons.insights, color: GameColors.goldAccent),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GameColors.borderSubtle),
                                    ),
                                    child: Column(
                                      children: [
                                        _StatDetailRow(
                                          label: 'STAMINA (STA)',
                                          value: '$totalSta',
                                          subtext: 'Base ${player.stamina} + Gear $bonusSta (+${totalSta * 10} Max HP, +${totalSta ~/ 4} Armor)',
                                          color: const Color(0xFF10B981),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'STRENGTH (STR)',
                                          value: '$totalStr',
                                          subtext: 'Base ${player.strength} + Gear $bonusStr (+${totalStr ~/ 3} Bonus DMG)',
                                          color: GameColors.crimsonBlood,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'AGILITY (AGI)',
                                          value: '$totalAgi',
                                          subtext: 'Base ${player.agility} + Gear $bonusAgi (Boosts Crit & Dodge)',
                                          color: GameColors.terminalGreen,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'INTELLIGENCE (INT)',
                                          value: '$totalInt',
                                          subtext: 'Base ${player.intelligence} + Gear $bonusInt (Magic power & resists)',
                                          color: GameColors.goldAccent,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Elemental Infusions (Fire, Ice, Poison, Void, Lightning)
                                  _StatsSectionTitle(title: 'ELEMENTAL INFUSIONS & OFFENSE', icon: Icons.local_fire_department, color: const Color(0xFFF97316)),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GameColors.borderSubtle),
                                    ),
                                    child: Column(
                                      children: [
                                        _StatDetailRow(
                                          label: 'Fire Damage',
                                          value: fireDmg > 0 ? '+$fireDmg' : '0',
                                          subtext: 'Applies Burn DoT over turns',
                                          color: const Color(0xFFEF4444),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Ice / Frost Damage',
                                          value: iceDmg > 0 ? '+$iceDmg' : '0',
                                          subtext: 'Slows enemy attack & cast speed',
                                          color: const Color(0xFF38BDF8),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Poison Damage',
                                          value: poisonDmg > 0 ? '+$poisonDmg' : '0',
                                          subtext: 'Stacking toxic corrosion',
                                          color: const Color(0xFF22C55E),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Void / Shadow Damage',
                                          value: voidDmg > 0 ? '+$voidDmg' : '0',
                                          subtext: 'Corrupts enemy code & armor',
                                          color: const Color(0xFFA855F7),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Lightning Damage',
                                          value: lightningDmg > 0 ? '+$lightningDmg' : '0',
                                          subtext: 'High variance & chain procs',
                                          color: const Color(0xFFFBBF24),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Elemental Resistances (Max 75% cap)
                                  _StatsSectionTitle(title: 'ELEMENTAL RESISTANCES', icon: Icons.shield_outlined, color: const Color(0xFF38BDF8)),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GameColors.borderSubtle),
                                    ),
                                    child: Column(
                                      children: [
                                        _StatDetailRow(
                                          label: 'All Resistances Bonus',
                                          value: '$allResist%',
                                          subtext: 'Universal mitigation across all schools',
                                          color: const Color(0xFF38BDF8),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Fire Resistance',
                                          value: '${(fireResist + allResist).clamp(0, 75)}%',
                                          subtext: 'Cap 75% (Base: $fireResist% + All: $allResist%)',
                                          color: const Color(0xFFEF4444),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Ice / Cold Resistance',
                                          value: '${(iceResist + allResist).clamp(0, 75)}%',
                                          subtext: 'Cap 75% (Base: $iceResist% + All: $allResist%)',
                                          color: const Color(0xFF38BDF8),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Poison Resistance',
                                          value: '${(poisonResist + allResist).clamp(0, 75)}%',
                                          subtext: 'Cap 75% (Base: $poisonResist% + All: $allResist%)',
                                          color: const Color(0xFF22C55E),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Void Resistance',
                                          value: '${(voidResist + allResist).clamp(0, 75)}%',
                                          subtext: 'Cap 75% (Base: $voidResist% + All: $allResist%)',
                                          color: const Color(0xFFA855F7),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Lightning Resistance',
                                          value: '${(lightningResist + allResist).clamp(0, 75)}%',
                                          subtext: 'Cap 75% (Base: $lightningResist% + All: $allResist%)',
                                          color: const Color(0xFFFBBF24),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Water / Pressure Resistance',
                                          value: '${(waterResist + allResist).clamp(0, 75)}%',
                                          subtext: 'Cap 75% (Base: $waterResist% + All: $allResist%)',
                                          color: const Color(0xFF06B6D4),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Combat Utility, Leech, Reflect, Luck & Drop Rates
                                  _StatsSectionTitle(title: 'COMBAT UTILITY & LUCK', icon: Icons.casino, color: GameColors.goldAccent),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgSurface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: GameColors.borderSubtle),
                                    ),
                                    child: Column(
                                      children: [
                                        _StatDetailRow(
                                          label: 'Life Steal (Leech)',
                                          value: '$lifeSteal%',
                                          subtext: 'Heals for % of physical/skill damage dealt',
                                          color: GameColors.crimsonBlood,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Damage Reflect (Thorns)',
                                          value: damageReflect > 0 ? '$damageReflect DMG' : '0',
                                          subtext: 'Retaliates when struck by melee attacks',
                                          color: const Color(0xFFF59E0B),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Magic Find (Item Quality Luck)',
                                          value: '+$magicFind%',
                                          subtext: 'Increases chance of Rare, Unique & Legendary drops',
                                          color: GameColors.goldAccent,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Gold / Silver Drop Rate',
                                          value: '+$goldDropRate%',
                                          subtext: 'Bonus currency drops from enemies & caches',
                                          color: GameColors.cyanRune,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Experience (EXP) Boost',
                                          value: '+$expGained%',
                                          subtext: 'Accelerates character level progression',
                                          color: const Color(0xFF10B981),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Boss Damage Multiplier',
                                          value: '+$bossDamage%',
                                          subtext: 'Multiplicative damage dealt to Echoes & Bosses',
                                          color: GameColors.crimsonBlood,
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Cooldown Reduction (CDR)',
                                          value: '$cooldownReduction%',
                                          subtext: 'Reduces turn cooldowns on active skills',
                                          color: const Color(0xFF8B5CF6),
                                        ),
                                        const Divider(color: GameColors.borderSubtle, height: 14),
                                        _StatDetailRow(
                                          label: 'Attack / Cast Speed',
                                          value: '+${attackSpeed + castSpeed}%',
                                          subtext: 'Atk: +$attackSpeed%, Cast: +$castSpeed%',
                                          color: GameColors.cyanRune,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Active Bonuses & Modifiers
                                  if (specialBuffs.isNotEmpty) ...[
                                    const SizedBox(height: 14),
                                    _StatsSectionTitle(title: 'EQUIPMENT MODIFIERS & TRAITS', icon: Icons.auto_awesome, color: GameColors.cyanRune),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: GameColors.bgSurface,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: GameColors.cyanRune.withValues(alpha: 0.4)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: specialBuffs.map((b) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 3),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.check_circle_outline, size: 14, color: GameColors.cyanRune),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    b,
                                                    style: GoogleFonts.jetBrainsMono(
                                                      fontSize: 11,
                                                      color: GameColors.textMain,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 24),
                                ],
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(color: GameColors.goldAccent),
                            ),
                            error: (e, _) => Center(child: Text('Error loading equipment: $e')),
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: GameColors.goldAccent),
                        ),
                        error: (e, _) => Center(child: Text('Error: $e')),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

class _StatsSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _StatsSectionTitle({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StatDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;
  final Color color;

  const _StatDetailRow({
    required this.label,
    required this.value,
    required this.subtext,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: GameColors.textMain,
                ),
              ),
              if (subtext.isNotEmpty)
                Text(
                  subtext,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9.5,
                    color: GameColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DossierBar extends StatelessWidget {
  final String label;
  final String valueText;
  final double fraction;
  final Color color;

  const _DossierBar({
    required this.label,
    required this.valueText,
    required this.fraction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: GameColors.textMuted,
              ),
            ),
            Text(
              valueText,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: GameColors.borderSubtle.withValues(alpha: 0.4),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}



// ─── World Map Modal ──────────────────────────────────────────────────────────
void _showMapModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: GameColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      side: BorderSide(color: GameColors.borderSubtle),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: GameColors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.map_outlined,
                        color: Color(0xFF8B5CF6), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'WORLD MAP',
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: GameColors.textMuted, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: GameColors.borderSubtle, height: 1),
              // Map body
              const Expanded(child: MinimapWidget()),
            ],
          );
        },
      );
    },
  );
}
