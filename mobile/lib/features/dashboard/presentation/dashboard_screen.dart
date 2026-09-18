import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vagabond_hero/core/database/app_database.dart';
import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';
import 'package:vagabond_hero/features/character/presentation/new_player_screen.dart';
import 'package:vagabond_hero/features/inventory/presentation/inventory_screen.dart';
import 'package:vagabond_hero/features/navigation/presentation/game_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(playerStreamProvider);
    final roomAsync = ref.watch(currentRoomStreamProvider);
    final inventoryAsync = ref.watch(playerInventoryProvider);

    return Scaffold(
      backgroundColor: GameColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Top Terminal Status Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: GameColors.bgSecondary,
                border: Border(
                  bottom: BorderSide(color: GameColors.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: GameColors.terminalGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'TERMINAL ONLINE // SHATTERED EXPANSE',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: GameColors.cyanRune,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  playerAsync.when(
                    data: (player) => player == null
                        ? const SizedBox()
                        : Row(
                            children: [
                              Text(
                                '?? ${player.silverPrisms}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: GameColors.goldAccent,
                                ),
                              ),
                            ],
                          ),
                    loading: () => const SizedBox(),
                    error: (_, _) => const SizedBox(),
                  ),
                ],
              ),
            ),

            // Scrollable Dashboard Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand / Logo Banner
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'VAGABOND HERO',
                            style: GoogleFonts.cinzel(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DARK FANTASY ISEKAI • TACTICAL ENGINE',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: GameColors.cyanRune,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // Active Character Card / Status
                    playerAsync.when(
                      data: (player) {
                        if (player == null) {
                          return _buildNoCharacterCard(context);
                        }
                        final items = inventoryAsync.value ?? [];
                        final room = roomAsync.value;
                        return _buildHeroHeroCard(context, ref, player, room, items);
                      },
                      loading: () => Container(
                        height: 180,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(color: GameColors.cyanRune),
                      ),
                      error: (err, _) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: GameColors.bgSecondary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GameColors.crimsonBlood),
                        ),
                        child: Text('Database Error: $err', style: const TextStyle(color: GameColors.crimsonBlood)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quick Action Launchers Grid
                    Text(
                      'SYSTEM OPERATIONAL PROTOCOLS',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: GameColors.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        // Resume/Enter Node Button
                        Expanded(
                          flex: 3,
                          child: _buildActionTile(
                            context: context,
                            icon: Icons.navigation_rounded,
                            iconColor: GameColors.cyanRune,
                            title: 'ENTER WORLD',
                            subtitle: 'Explore active node & rooms',
                            badge: 'NODE ${roomAsync.value?.id ?? 101}',
                            badgeColor: GameColors.cyanRune,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const GameScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // New Character Button
                        Expanded(
                          flex: 2,
                          child: _buildActionTile(
                            context: context,
                            icon: Icons.person_add_alt_1,
                            iconColor: GameColors.goldAccent,
                            title: 'NEW HERO',
                            subtitle: 'Awaken anew',
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const NewPlayerScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        // Equipment / Bag
                        Expanded(
                          child: _buildActionTile(
                            context: context,
                            icon: Icons.shield_outlined,
                            iconColor: const Color(0xFFA855F7),
                            title: 'ARMORY & BAG',
                            subtitle: '${inventoryAsync.value?.length ?? 0} relics gathered',
                            onTap: () {
                              HapticFeedback.selectionClick();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const InventoryScreen(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // World Guide / Lore preview
                        Expanded(
                          child: _buildActionTile(
                            context: context,
                            icon: Icons.menu_book_rounded,
                            iconColor: GameColors.terminalGreen,
                            title: 'CODEX & LORE',
                            subtitle: '5 Acts • 21 Classes',
                            onTap: () => _showCodexModal(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Active Node Lore Dispatch Card
                    roomAsync.when(
                      data: (room) => room == null
                          ? const SizedBox()
                          : Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: GameColors.bgSecondary,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: GameColors.borderSubtle),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.radar, color: GameColors.cyanRune, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        'TELEMETRY // CURRENT VICINITY',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: GameColors.cyanRune,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    room.title,
                                    style: GoogleFonts.cinzel(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    room.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: GameColors.textMuted,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      loading: () => const SizedBox(),
                      error: (_, _) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCharacterCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: GameColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GameColors.borderSubtle),
      ),
      child: Column(
        children: [
          const Icon(Icons.person_outline, size: 48, color: GameColors.cyanRune),
          const SizedBox(height: 12),
          Text(
            'NO WANDERER DETECTED',
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Awaken your consciousness into the Shattered Expanse to begin exploring.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: GameColors.textMuted),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NewPlayerScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GameColors.cyanRune,
              foregroundColor: Colors.black,
            ),
            child: const Text('CREATE HERO'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeroCard(
    BuildContext context,
    WidgetRef ref,
    PlayerData player,
    RoomData? room,
    List<ItemData> items,
  ) {
    final equippedItems = items.where((i) => i.isEquipped).toList();
    final hpPercent = (player.currentHp / player.baseHp).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: GameColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GameColors.borderActive.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name, Class, Level
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: GameColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: GameColors.cyanRune.withValues(alpha: 0.6)),
                ),
                alignment: Alignment.center,
                child: Text(
                  player.jobClass == 'Juggernaut'
                      ? '???'
                      : player.jobClass == 'Phantom'
                          ? '?'
                          : player.jobClass == 'Weaver'
                              ? '??'
                              : player.jobClass == 'Warden'
                                  ? '??'
                                  : '??',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          player.name,
                          style: GoogleFonts.cinzel(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: GameColors.goldAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: GameColors.goldAccent.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            'LEVEL ${player.level}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: GameColors.goldAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${player.jobClass} • ${room?.title ?? 'The Ashen Expanse'}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: GameColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // HP Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VITALITY (HP)',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.textMuted),
                  ),
                  Text(
                    '${player.currentHp} / ${player.baseHp}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: hpPercent < 0.3 ? GameColors.crimsonBlood : GameColors.terminalGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: hpPercent,
                  minHeight: 6,
                  backgroundColor: GameColors.bgSecondary,
                  valueColor: AlwaysStoppedAnimation(
                    hpPercent < 0.3 ? GameColors.crimsonBlood : GameColors.terminalGreen,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Core Stats strip
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: GameColors.bgSecondary,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: GameColors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatMetric('STR', player.strength, const Color(0xFFEF4444)),
                _buildStatMetric('AGI', player.agility, const Color(0xFFFACC15)),
                _buildStatMetric('INT', player.intelligence, const Color(0xFF38BDF8)),
                _buildStatMetric('STA', player.stamina, const Color(0xFF10B981)),
                _buildStatMetric('GEAR', equippedItems.length, GameColors.cyanRune),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatMetric(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(fontSize: 9.5, color: GameColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          '$value',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GameColors.bgSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GameColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: (badgeColor ?? GameColors.cyanRune).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: (badgeColor ?? GameColors.cyanRune).withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: badgeColor ?? GameColors.cyanRune,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.cinzel(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: GameColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCodexModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: GameColors.bgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('??', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Text(
                    'VAULT OF THE EXPANSE',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: GameColors.textMuted),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Vagabond Hero is governed by 5 Acts in the Shattered Expanse:\n'
                '• Act I: The Ashen Awakening (Nodes 101–104)\n'
                '• Act II: The Sunken Core\n'
                '• Act III: Spire of the Glitched Sky\n'
                '• Act IV: The Void Foundry\n'
                '• Act V: The Terminal of Creation\n\n'
                'Classes evolve through 4 tiers: Vagabond (Lv 1–20) ? 1st Awakening (Lv 21–50) ? 2nd Mastery (Lv 51–70) ? Level 70+ Echo Specialization.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: GameColors.textMain,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
