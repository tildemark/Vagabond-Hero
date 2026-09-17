import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vagabond_hero/core/database/app_database.dart';
import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';

// ---------------------------------------------------------------------------
//  Data model for a positioned node on the map grid
// ---------------------------------------------------------------------------
class _MapNode {
  final RoomData room;
  final int col;
  final int row;
  const _MapNode(this.room, this.col, this.row);
}

// ---------------------------------------------------------------------------
//  BFS layout: walk graph from startId, assign grid (col, row) positions
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
//  CustomPainter
// ---------------------------------------------------------------------------
class _MinimapPainter extends CustomPainter {
  final List<_MapNode> nodes;
  final Map<int, _MapNode> byId;
  final int currentRoomId;

  _MinimapPainter({
    required this.nodes,
    required this.currentRoomId,
  }) : byId = {for (final n in nodes) n.room.id: n};

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 24.0;
    const legendH = 36.0;
    final availW = size.width - pad * 2;
    final availH = size.height - pad * 2 - legendH;
    if (nodes.isEmpty) return;

    final maxCol = nodes.map((n) => n.col).reduce(math.max).toDouble();
    final minCol = nodes.map((n) => n.col).reduce(math.min).toDouble();
    final maxRow = nodes.map((n) => n.row).reduce(math.max).toDouble();
    final minRow = nodes.map((n) => n.row).reduce(math.min).toDouble();

    final spanCol = (maxCol - minCol + 1).clamp(1.0, 100.0);
    final spanRow = (maxRow - minRow + 1).clamp(1.0, 100.0);

    final cell = math.min(availW / spanCol, availH / spanRow).clamp(20.0, 54.0);
    final half = cell * 0.36;

    final totalW = spanCol * cell;
    final totalH = spanRow * cell;
    final cx = pad + (availW - totalW) / 2 + cell / 2;
    final cy = pad + (availH - totalH) / 2 + cell / 2;

    Offset pos(int col, int row) => Offset(
          cx + (col - minCol) * cell,
          cy + (row - minRow) * cell,
        );

    final corridorPaint = Paint()
      ..color = GameColors.cyanRune.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dimCorridorPaint = Paint()
      ..color = GameColors.borderSubtle.withValues(alpha: 0.4)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Corridors first
    for (final node in nodes) {
      final from = pos(node.col, node.row);
      final p = node.room.isExplored ? corridorPaint : dimCorridorPaint;

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

    // Nodes
    for (final node in nodes) {
      final center = pos(node.col, node.row);
      final rect = Rect.fromCenter(center: center, width: half * 2, height: half * 2);
      final isCurrent = node.room.id == currentRoomId;
      final isExplored = node.room.isExplored;

      if (isCurrent) {
        // Glow ring
        canvas.drawCircle(
          center, half * 1.6,
          Paint()..color = GameColors.cyanRune.withValues(alpha: 0.15)..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          center, half * 1.45,
          Paint()
            ..color = GameColors.cyanRune.withValues(alpha: 0.55)
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke,
        );
        canvas.drawRect(rect, Paint()..color = GameColors.cyanRune..style = PaintingStyle.fill);
        _label(canvas, '${node.room.id}', center, Colors.black, cell * 0.22);
      } else if (isExplored) {
        canvas.drawRect(rect, Paint()..color = const Color(0xFF0F2A2A)..style = PaintingStyle.fill);
        canvas.drawRect(
          rect,
          Paint()..color = GameColors.cyanRune.withValues(alpha: 0.45)..strokeWidth = 1..style = PaintingStyle.stroke,
        );
        _label(canvas, '${node.room.id}', center, GameColors.textMuted, cell * 0.20);
      } else {
        canvas.drawRect(rect, Paint()..color = GameColors.bgCard..style = PaintingStyle.fill);
        canvas.drawRect(
          rect,
          Paint()..color = GameColors.borderSubtle..strokeWidth = 0.8..style = PaintingStyle.stroke,
        );
        _label(canvas, '?', center, GameColors.borderSubtle, cell * 0.22);
      }
    }
  }

  void _label(Canvas canvas, String text, Offset c, Color color, double size) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: size.clamp(8, 14), color: color, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_MinimapPainter old) =>
      old.currentRoomId != currentRoomId || old.nodes.length != nodes.length;
}

// ---------------------------------------------------------------------------
//  Public widget
// ---------------------------------------------------------------------------
class MinimapWidget extends ConsumerWidget {
  const MinimapWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoomsAsync = ref.watch(allRoomsProvider);
    final currentRoomId =
        ref.watch(playerStreamProvider).value?.currentRoomId ?? 101;

    return allRoomsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: GameColors.cyanRune)),
      error: (e, _) => Center(child: Text('Map error: $e')),
      data: (allRooms) {
        final nodes = _buildLayout(allRooms, 101);
        if (nodes.isEmpty) {
          return const Center(
            child: Text('No map data.',
                style: TextStyle(color: GameColors.textMuted)),
          );
        }

        return Column(
          children: [
            Expanded(
              child: CustomPaint(
                painter: _MinimapPainter(
                  nodes: nodes,
                  currentRoomId: currentRoomId,
                ),
                child: const SizedBox.expand(),
              ),
            ),
            // Legend
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: GameColors.cyanRune, label: 'You are here'),
                  const SizedBox(width: 16),
                  _LegendDot(color: const Color(0xFF1A6A6A), label: 'Explored'),
                  const SizedBox(width: 16),
                  _LegendDot(color: GameColors.borderSubtle, label: 'Unknown'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.textMuted)),
      ],
    );
  }
}
