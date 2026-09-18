import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:drift/drift.dart' show Value;
import 'package:vagabond_hero/core/database/app_database.dart';
import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// World Map Act Metadata
// ─────────────────────────────────────────────────────────────────────────────
class ActInfo {
  final int actNumber;
  final String title;
  final String subtitle;
  final String description;
  final String levelRecommendation;
  final int entryRoomId;
  final IconData icon;
  final Color themeColor;

  const ActInfo({
    required this.actNumber,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.levelRecommendation,
    required this.entryRoomId,
    required this.icon,
    required this.themeColor,
  });
}

const List<ActInfo> kAllActs = [
  ActInfo(
    actNumber: 1,
    title: 'ACT I: THE ASHEN WOODS',
    subtitle: 'Awakening in Petrified Fog',
    description:
        'A petrified landscape suspended beneath a corrupted sky. Ancient CRT monoliths, mutated arachnids, and rogue survivors cluster around the Vanguard Ward.',
    levelRecommendation: 'Lv. 1 – 8',
    entryRoomId: 101,
    icon: Icons.forest_outlined,
    themeColor: GameColors.cyanRune,
  ),
  ActInfo(
    actNumber: 2,
    title: 'ACT II: THE SUNKEN CITY',
    subtitle: 'Subterranean Liquid Data',
    description:
        'A vast gothic metropolis drowned in glowing blue liquid Void. High hydrostatic pressure, rogue security automatons, and submerged cathedral vaults.',
    levelRecommendation: 'Lv. 8 – 18',
    entryRoomId: 2101,
    icon: Icons.water_drop_outlined,
    themeColor: Color(0xFF38BDF8),
  ),
  ActInfo(
    actNumber: 3,
    title: 'ACT III: THE CLOCKWORK PEAKS',
    subtitle: 'Malfunctioning Time Core',
    description:
        'Colossal brass gears, pistons, and frozen blizzards. Corrupted automata and time dilation anomalies grinding the world to an icy halt.',
    levelRecommendation: 'Lv. 18 – 28',
    entryRoomId: 3101,
    icon: Icons.settings_suggest_outlined,
    themeColor: Color(0xFFF59E0B),
  ),
  ActInfo(
    actNumber: 4,
    title: 'ACT IV: THE ASTRAL SERVERS',
    subtitle: 'Cosmic Mainframe Core',
    description:
        'The fantasy veil dissolves entirely. Floating monolith server towers, liquid data rivers, and celestial AI security daemons guarding root memory.',
    levelRecommendation: 'Lv. 28 – 38',
    entryRoomId: 4101,
    icon: Icons.memory_outlined,
    themeColor: Color(0xFFA855F7),
  ),
  ActInfo(
    actNumber: 5,
    title: 'ACT V: UNALLOCATED SPACE',
    subtitle: 'System Quarantine & Purge',
    description:
        'Wireframe geometry, absolute dark voids, and deprecated memory sectors. The foreign intruder purge protocol is active.',
    levelRecommendation: 'Lv. 38+',
    entryRoomId: 5101,
    icon: Icons.terminal_rounded,
    themeColor: Color(0xFFEF4444),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Unified Maps Screen (Tabbed: AREA / NODE MAP vs WORLD MAP 5 ACTS)
// ─────────────────────────────────────────────────────────────────────────────
class MapsScreen extends ConsumerStatefulWidget {
  final int initialTabIndex; // 0: Area Map, 1: World Map

  const MapsScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RoomData? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerStreamProvider).value;
    final currentRoomId = player?.currentRoomId ?? 101;
    final actsCompleted = player?.actsCompleted ?? 0;

    return Scaffold(
      backgroundColor: GameColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: GameColors.bgSecondary,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const Icon(Icons.explore_outlined, color: GameColors.cyanRune, size: 20),
            const SizedBox(width: 8),
            Text(
              'CARTOGRAPHY & NAVIGATION',
              style: GoogleFonts.cinzel(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GameColors.cyanRune,
          indicatorWeight: 2.5,
          labelColor: GameColors.cyanRune,
          unselectedLabelColor: GameColors.textMuted,
          labelStyle: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.hub_outlined, size: 18),
              text: 'AREA / NODE MAP',
            ),
            Tab(
              icon: Icon(Icons.public_outlined, size: 18),
              text: 'WORLD MAP (5 ACTS)',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── TAB 1: Area / Node Map
          _buildAreaMapView(currentRoomId),

          // ── TAB 2: World Map (5 Acts)
          _buildWorldMapView(currentRoomId, actsCompleted),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Area Map View
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildAreaMapView(int currentRoomId) {
    final allRoomsAsync = ref.watch(allRoomsProvider);
    final allMobsAsync = ref.watch(allActiveMobsByRoomProvider);

    return allRoomsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: GameColors.cyanRune),
      ),
      error: (e, _) => Center(
        child: Text('Map telemetry failure: $e',
            style: const TextStyle(color: GameColors.crimsonBlood)),
      ),
      data: (allRooms) {
        final activeMobs = allMobsAsync.value ?? {};
        final nodes = _buildLayout(allRooms, 101);

        return Column(
          children: [
            // Top telemetry sub-bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: GameColors.bgSecondary,
                border: Border(bottom: BorderSide(color: GameColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.radar, size: 14, color: GameColors.cyanRune),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'ACT 1 // THE ASHEN EXPEDITION',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: GameColors.cyanRune,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: GameColors.borderSubtle, width: 0.8),
                    ),
                    child: Text(
                      '${allRooms.values.where((r) => r.isExplored).length}/${allRooms.length} SCANNED',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        color: GameColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Interactive Map Canvas
            Expanded(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final maxCol = nodes.map((n) => n.col).fold(0, math.max);
                      final minCol = nodes.map((n) => n.col).fold(0, math.min);
                      final maxRow = nodes.map((n) => n.row).fold(0, math.max);
                      final minRow = nodes.map((n) => n.row).fold(0, math.min);

                      final spanW = ((maxCol - minCol + 3) * 64.0).clamp(constraints.maxWidth, 1800.0);
                      final spanH = ((maxRow - minRow + 3) * 64.0).clamp(constraints.maxHeight, 1800.0);
                      final canvasSize = Size(spanW, spanH);

                      return InteractiveViewer(
                        clipBehavior: Clip.hardEdge,
                        boundaryMargin: const EdgeInsets.all(40),
                        minScale: 0.3,
                        maxScale: 2.5,
                        child: CustomPaint(
                          size: canvasSize,
                          painter: _ExpandedAreaMapPainter(
                            nodes: nodes,
                            currentRoomId: currentRoomId,
                            activeMobs: activeMobs,
                            selectedRoomId: _selectedRoom?.id,
                          ),
                        ),
                      );
                    },
                  ),

                  // Selected room preview card overlay at bottom
                  if (_selectedRoom != null)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 48,
                      child: _buildRoomDetailCard(_selectedRoom!),
                    ),
                ],
              ),
            ),

            // Map Tactical Legend
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: GameColors.bgSecondary,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _legendItem(GameColors.cyanRune, 'Current Node'),
                    const SizedBox(width: 14),
                    _legendItem(const Color(0xFF1E3A5F), 'Explored'),
                    const SizedBox(width: 14),
                    _legendItem(GameColors.borderSubtle, 'Fog of War'),
                    const SizedBox(width: 14),
                    _legendBadge('👑', 'Rare Mini-Boss'),
                    const SizedBox(width: 14),
                    _legendBadge('⚔️', 'Combat Encounter'),
                    const SizedBox(width: 14),
                    _legendBadge('🛡️', 'Sanctuary Hub'),
                    const SizedBox(width: 14),
                    _legendBadge('🌀', 'Act Gateway'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.textMuted)),
      ],
    );
  }

  Widget _legendBadge(String icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 11)),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.textMuted)),
      ],
    );
  }

  Widget _buildRoomDetailCard(RoomData room) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GameColors.bgSecondary.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GameColors.cyanRune.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.7),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'ROOM ${room.id} // ${room.title.toUpperCase()}',
                style: GoogleFonts.cinzel(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: GameColors.cyanRune,
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 16, color: GameColors.textMuted),
                onPressed: () => setState(() => _selectedRoom = null),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            room.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 11, color: GameColors.textMuted),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'EXITS: ',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: GameColors.goldAccent,
                ),
              ),
              if (room.northExitId != null) _exitChip('N: ${room.northExitId}'),
              if (room.southExitId != null) _exitChip('S: ${room.southExitId}'),
              if (room.eastExitId != null) _exitChip('E: ${room.eastExitId}'),
              if (room.westExitId != null) _exitChip('W: ${room.westExitId}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _exitChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: GameColors.borderSubtle),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(fontSize: 9.5, color: Colors.white70),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // World Map View (5 Acts with Teleportation & Unlocked Status)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildWorldMapView(int currentRoomId, int actsCompleted) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kAllActs.length,
      itemBuilder: (context, index) {
        final act = kAllActs[index];
        // Act 1 is always unlocked.
        // Subsequent acts unlock if previous act is completed (actsCompleted >= act.actNumber - 1).
        final isUnlocked = act.actNumber == 1 || actsCompleted >= (act.actNumber - 1);
        final isCurrentAct = (act.actNumber == 1 && currentRoomId < 2000) ||
            (act.actNumber == 2 && currentRoomId >= 2000 && currentRoomId < 3000);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isUnlocked ? GameColors.bgSecondary : const Color(0xFF0F1218),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrentAct
                  ? act.themeColor
                  : (isUnlocked
                      ? act.themeColor.withValues(alpha: 0.35)
                      : GameColors.borderSubtle.withValues(alpha: 0.3)),
              width: isCurrentAct ? 1.8 : 1.0,
            ),
            boxShadow: isCurrentAct
                ? [
                    BoxShadow(
                      color: act.themeColor.withValues(alpha: 0.15),
                      blurRadius: 14,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header ribbon
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? act.themeColor.withValues(alpha: 0.08)
                      : Colors.black26,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                ),
                child: Row(
                  children: [
                    Icon(
                      act.icon,
                      color: isUnlocked ? act.themeColor : GameColors.textMuted,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            act.title,
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? Colors.white : GameColors.textMuted,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            act.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isUnlocked
                                  ? act.themeColor.withValues(alpha: 0.9)
                                  : GameColors.textMuted.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Unlock Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? (isCurrentAct
                                ? act.themeColor.withValues(alpha: 0.2)
                                : Colors.black45)
                            : Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isUnlocked ? act.themeColor : GameColors.borderSubtle,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUnlocked
                                ? (isCurrentAct ? Icons.my_location : Icons.check_circle_outline)
                                : Icons.lock_outline,
                            size: 13,
                            color: isUnlocked ? act.themeColor : GameColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCurrentAct
                                ? 'ACTIVE'
                                : (isUnlocked ? 'OPEN' : 'LOCKED'),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? act.themeColor : GameColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Description & Level Advisory
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      act.description,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        height: 1.45,
                        color: isUnlocked ? GameColors.textMuted : const Color(0xFF555C6E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'THREAT: ${act.levelRecommendation}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: isUnlocked ? GameColors.goldAccent : GameColors.textMuted,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Teleport Button
                        if (isUnlocked)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCurrentAct
                                  ? act.themeColor.withValues(alpha: 0.15)
                                  : act.themeColor.withValues(alpha: 0.25),
                              foregroundColor: act.themeColor,
                              side: BorderSide(color: act.themeColor, width: 1.2),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.flash_on_rounded, size: 15),
                            label: Text(
                              isCurrentAct ? 'TELEPORT TO HUB' : 'FAST TRAVEL',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            onPressed: () => _teleportToAct(act),
                          )
                        else
                          Row(
                            children: [
                              const Icon(Icons.info_outline, size: 12, color: GameColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                'Defeat Act ${act.actNumber - 1} Boss to unlock',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: GameColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _teleportToAct(ActInfo act) async {
    HapticFeedback.heavyImpact();
    final db = ref.read(databaseProvider);
    final player = ref.read(playerStreamProvider).value;
    if (player == null) return;

    // Destination room: 302 (Vanguard Safe Hub) for Act 1, entryRoomId for other acts
    final destRoomId = act.actNumber == 1 ? 302 : act.entryRoomId;

    await (db.update(db.players)..where((t) => t.id.equals(player.id))).write(
      PlayersCompanion(
        currentRoomId: Value(destRoomId),
      ),
    );

    // Mark destination room explored
    await (db.update(db.rooms)..where((t) => t.id.equals(destRoomId))).write(
      const RoomsCompanion(isExplored: Value(true)),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: GameColors.bgSecondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: act.themeColor),
          ),
          content: Row(
            children: [
              Icon(Icons.bolt, color: act.themeColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Translocated to ${act.title} (Node $destRoomId)',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BFS Grid Graph Model
// ─────────────────────────────────────────────────────────────────────────────
class _MapNode {
  final RoomData room;
  final int col;
  final int row;
  const _MapNode(this.room, this.col, this.row);
}

List<_MapNode> _buildLayout(Map<int, RoomData> allRooms, int startId) {
  if (!allRooms.containsKey(startId)) return [];

  final positions = <int, (int, int)>{};
  final queue = Queue<(int, int, int)>();
  queue.add((startId, 0, 0));
  positions[startId] = (0, 0);

  while (queue.isNotEmpty) {
    final (id, col, row) = queue.removeFirst();
    final room = allRooms[id];
    if (room == null) continue;

    void tryVisit(int? exitId, int dc, int dr) {
      if (exitId == null || positions.containsKey(exitId)) return;
      positions[exitId] = (col + dc, row + dr);
      queue.add((exitId, col + dc, row + dr));
    }

    tryVisit(room.northExitId, 0, -1);
    tryVisit(room.southExitId, 0, 1);
    tryVisit(room.westExitId, -1, 0);
    tryVisit(room.eastExitId, 1, 0);
  }

  return positions.entries.map((e) {
    final room = allRooms[e.key]!;
    return _MapNode(room, e.value.$1, e.value.$2);
  }).toList();
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Painter with Combat, Hub, and Boss Overlays
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandedAreaMapPainter extends CustomPainter {
  final List<_MapNode> nodes;
  final int currentRoomId;
  final Map<int, List<MobData>> activeMobs;
  final int? selectedRoomId;
  final Map<int, _MapNode> byId;

  _ExpandedAreaMapPainter({
    required this.nodes,
    required this.currentRoomId,
    required this.activeMobs,
    this.selectedRoomId,
  }) : byId = {for (final n in nodes) n.room.id: n};

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final maxCol = nodes.map((n) => n.col).reduce(math.max).toDouble();
    final minCol = nodes.map((n) => n.col).reduce(math.min).toDouble();
    final maxRow = nodes.map((n) => n.row).reduce(math.max).toDouble();
    final minRow = nodes.map((n) => n.row).reduce(math.min).toDouble();

    final spanCol = (maxCol - minCol + 1).clamp(1.0, 100.0);
    final spanRow = (maxRow - minRow + 1).clamp(1.0, 100.0);

    const cell = 64.0;
    const half = cell * 0.36;

    final totalW = spanCol * cell;
    final totalH = spanRow * cell;
    final cx = (size.width - totalW) / 2 + cell / 2;
    final cy = (size.height - totalH) / 2 + cell / 2;

    Offset pos(int col, int row) => Offset(
          cx + (col - minCol) * cell,
          cy + (row - minRow) * cell,
        );

    final exploredCorridorPaint = Paint()
      ..color = GameColors.cyanRune.withValues(alpha: 0.45)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dimCorridorPaint = Paint()
      ..color = GameColors.borderSubtle.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 1. Draw Corridors
    for (final node in nodes) {
      final from = pos(node.col, node.row);
      final p = node.room.isExplored ? exploredCorridorPaint : dimCorridorPaint;

      void drawLine(int? exitId) {
        final target = byId[exitId];
        if (target == null) return;
        canvas.drawLine(from, pos(target.col, target.row), p);
      }

      drawLine(node.room.northExitId);
      drawLine(node.room.southExitId);
      drawLine(node.room.eastExitId);
      drawLine(node.room.westExitId);
    }

    // 2. Draw Nodes
    for (final node in nodes) {
      final center = pos(node.col, node.row);
      final rect = Rect.fromCenter(center: center, width: half * 2, height: half * 2);
      final isCurrent = node.room.id == currentRoomId;
      final isExplored = node.room.isExplored;
      final isSelected = node.room.id == selectedRoomId;
      final mobsInRoom = activeMobs[node.room.id] ?? [];

      // Determine room archetype
      final isBossRoom = node.room.id == 603 || node.room.id == 204 || node.room.id == 404 || node.room.id == 503;
      final isGateway = node.room.id == 604;
      final isSafeHub = node.room.id >= 301 && node.room.id <= 304;

      if (isCurrent) {
        // Radar pulse glow
        canvas.drawCircle(
          center,
          half * 1.8,
          Paint()
            ..color = GameColors.cyanRune.withValues(alpha: 0.2)
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          center,
          half * 1.45,
          Paint()
            ..color = GameColors.cyanRune.withValues(alpha: 0.6)
            ..strokeWidth = 1.8
            ..style = PaintingStyle.stroke,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          Paint()..color = GameColors.cyanRune..style = PaintingStyle.fill,
        );
        _drawText(canvas, '${node.room.id}', center, Colors.black, 10.5, true);
      } else if (isExplored) {
        final nodeColor = isBossRoom
            ? const Color(0xFF3F1418)
            : (isSafeHub
                ? const Color(0xFF1E3A2F)
                : (isGateway ? const Color(0xFF281E48) : const Color(0xFF102636)));

        final borderColor = isBossRoom
            ? GameColors.crimsonBlood
            : (isSafeHub
                ? GameColors.terminalGreen
                : (isGateway ? const Color(0xFFA855F7) : GameColors.cyanRune.withValues(alpha: 0.5)));

        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          Paint()..color = nodeColor..style = PaintingStyle.fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          Paint()..color = borderColor..strokeWidth = isSelected ? 2.2 : 1.0..style = PaintingStyle.stroke,
        );
        _drawText(canvas, '${node.room.id}', center, Colors.white, 9.5, false);

        // Render tactical badge icons
        if (isBossRoom) {
          _drawText(canvas, '💀', Offset(center.dx + half * 0.8, center.dy - half * 0.8), Colors.white, 10, false);
        } else if (mobsInRoom.any((m) => m.isMiniBoss)) {
          _drawText(canvas, '👑', Offset(center.dx + half * 0.8, center.dy - half * 0.8), Colors.white, 10, false);
        } else if (mobsInRoom.isNotEmpty) {
          _drawText(canvas, '⚔️', Offset(center.dx + half * 0.8, center.dy - half * 0.8), Colors.white, 9, false);
        } else if (isSafeHub) {
          _drawText(canvas, '🛡️', Offset(center.dx + half * 0.8, center.dy - half * 0.8), Colors.white, 9, false);
        } else if (isGateway) {
          _drawText(canvas, '🌀', Offset(center.dx + half * 0.8, center.dy - half * 0.8), Colors.white, 10, false);
        }
      } else {
        // Fog of war
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          Paint()..color = GameColors.bgCard..style = PaintingStyle.fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)),
          Paint()..color = GameColors.borderSubtle.withValues(alpha: 0.6)..strokeWidth = 0.8..style = PaintingStyle.stroke,
        );
        _drawText(canvas, '?', center, GameColors.borderSubtle, 11, true);
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset c, Color color, double size, bool bold) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_ExpandedAreaMapPainter old) => true;
}
