import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';
import 'package:vagabond_hero/features/combat/domain/combat_engine.dart';
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: GameColors.cyanRune),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'VAGABOND HERO',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const Spacer(),
            playerAsync.when(
              data: (player) => player == null
                  ? const SizedBox()
                  : Row(
                      children: [
                        Text(
                          'Lv.${player.level} ${player.jobClass}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: GameColors.goldAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'HP: ${player.currentHp}/${player.baseHp}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: player.currentHp < (player.baseHp * 0.3)
                                ? GameColors.crimsonBlood
                                : GameColors.terminalGreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '💎 ${player.silverPrisms}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: GameColors.cyanRune,
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.backpack_outlined,
                              size: 20, color: GameColors.cyanRune),
                          tooltip: 'Inventory',
                          onPressed: () => _showInventoryModal(context, ref),
                        ),
                      ],
                    ),
              loading: () => const SizedBox(),
              error: (_, _) => const SizedBox(),
            ),
          ],
        ),
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

            // Bottom Navigation Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavButton(
                        label: 'North',
                        icon: Icons.arrow_upward,
                        enabled: room.northExitId != null,
                        onPressed: () => nav.moveTo(Direction.north),
                      ),
                      _NavButton(
                        label: 'South',
                        icon: Icons.arrow_downward,
                        enabled: room.southExitId != null,
                        onPressed: () => nav.moveTo(Direction.south),
                      ),
                      _NavButton(
                        label: 'West',
                        icon: Icons.arrow_back,
                        enabled: room.westExitId != null,
                        onPressed: () => nav.moveTo(Direction.west),
                      ),
                      _NavButton(
                        label: 'East',
                        icon: Icons.arrow_forward,
                        enabled: room.eastExitId != null,
                        onPressed: () => nav.moveTo(Direction.east),
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

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: enabled ? GameColors.cyanRune : GameColors.textDim,
        side: BorderSide(
          color: enabled ? GameColors.cyanDim : GameColors.borderSubtle,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: GoogleFonts.inter(fontSize: 12),
      ),
    );
  }
}

void _showInventoryModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: GameColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      side: BorderSide(color: GameColors.borderSubtle),
    ),
    builder: (context) {
      final itemsAsync = ref.watch(playerInventoryProvider);

      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.backpack, color: GameColors.cyanRune, size: 20),
                const SizedBox(width: 8),
                Text(
                  'INVENTORY & GEAR',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: GameColors.textMuted, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: GameColors.borderSubtle),
            const SizedBox(height: 8),
            Expanded(
              child: itemsAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Your satchel is currently empty.',
                        style: GoogleFonts.inter(
                          color: GameColors.textDim,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      Color rarityColor = GameColors.rarityNormal;
                      if (item.rarity == 'Magic') rarityColor = GameColors.rarityMagic;
                      if (item.rarity == 'Rare') rarityColor = GameColors.rarityRare;
                      if (item.rarity == 'Legendary') rarityColor = GameColors.rarityLegendary;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GameColors.bgCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: rarityColor.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.baseType == 'Weapon'
                                  ? Icons.colorize
                                  : Icons.shield_outlined,
                              color: rarityColor,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      color: rarityColor,
                                    ),
                                  ),
                                  Text(
                                    '${item.rarity} ${item.baseType} • DMG: ${item.minDamage}-${item.maxDamage}',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 11,
                                      color: GameColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.isEquipped)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: GameColors.cyanRune.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: GameColors.cyanRune),
                                ),
                                child: Text(
                                  'EQUIPPED',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9,
                                    color: GameColors.cyanRune,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: GameColors.cyanRune),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      );
    },
  );
}
