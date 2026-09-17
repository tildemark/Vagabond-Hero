import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vagabond_hero/core/database/app_database.dart';
import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';
import 'package:vagabond_hero/features/inventory/domain/equipment_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Constants
// ─────────────────────────────────────────────────────────────────────────────
const _slots = ['Head', 'Chest', 'MainHand', 'OffHand', 'Feet'];

final _slotIcon = {
  'Head': Icons.face_outlined,
  'Chest': Icons.accessibility_new,
  'MainHand': Icons.colorize,
  'OffHand': Icons.shield_outlined,
  'Feet': Icons.directions_walk,
};

final _slotLabel = {
  'Head': 'HEAD',
  'Chest': 'CHEST',
  'MainHand': 'MAIN',
  'OffHand': 'OFF',
  'Feet': 'FEET',
};

Color _rarityColor(String rarity) {
  switch (rarity) {
    case 'Magic':
      return GameColors.rarityMagic;
    case 'Rare':
      return GameColors.rarityRare;
    case 'Legendary':
      return GameColors.rarityLegendary;
    default:
      return GameColors.rarityNormal;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Main modal widget (call via _showInventoryScreen)
// ─────────────────────────────────────────────────────────────────────────────
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(playerInventoryProvider);

    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 4),
          width: 36, height: 4,
          decoration: BoxDecoration(
            color: GameColors.borderSubtle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.backpack, color: GameColors.cyanRune, size: 20),
              const SizedBox(width: 8),
              Text(
                'GEAR & INVENTORY',
                style: GoogleFonts.cinzel(
                  fontSize: 15,
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
        ),
        // Tabs
        Container(
          color: GameColors.bgCard,
          child: TabBar(
            controller: _tab,
            indicatorColor: GameColors.cyanRune,
            labelColor: GameColors.cyanRune,
            unselectedLabelColor: GameColors.textMuted,
            labelStyle: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: '⚔  EQUIPPED'),
              Tab(text: '🎒  BAG'),
            ],
          ),
        ),
        const Divider(height: 1, color: GameColors.borderSubtle),
        // Content
        Expanded(
          child: itemsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(color: GameColors.cyanRune)),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (items) {
              final equipped = {
                for (final s in _slots)
                  s: items.where((i) => i.isEquipped && i.equipSlot == s).firstOrNull
              };
              final bag = items.where((i) => !i.isEquipped).toList();

              return TabBarView(
                controller: _tab,
                children: [
                  _EquippedTab(equipped: equipped, bag: bag),
                  _BagTab(items: bag, equipped: equipped),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab 1: Paper-doll equipment view
// ─────────────────────────────────────────────────────────────────────────────
class _EquippedTab extends ConsumerWidget {
  final Map<String, ItemData?> equipped;
  final List<ItemData> bag;
  const _EquippedTab({required this.equipped, required this.bag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.read(equipmentServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Paper doll layout ──────────────────────────────
          Center(
            child: SizedBox(
              width: 280,
              child: Column(
                children: [
                  // Head
                  _SlotCard(
                    slot: 'Head',
                    item: equipped['Head'],
                    onTap: () => _pickForSlot(context, ref, svc, 'Head', bag),
                    onUnequip: equipped['Head'] != null
                        ? () => svc.unequip(equipped['Head']!)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  // Chest
                  _SlotCard(
                    slot: 'Chest',
                    item: equipped['Chest'],
                    onTap: () => _pickForSlot(context, ref, svc, 'Chest', bag),
                    onUnequip: equipped['Chest'] != null
                        ? () => svc.unequip(equipped['Chest']!)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  // Hands row
                  Row(
                    children: [
                      Expanded(
                        child: _SlotCard(
                          slot: 'MainHand',
                          item: equipped['MainHand'],
                          onTap: () => _pickForSlot(context, ref, svc, 'MainHand', bag),
                          onUnequip: equipped['MainHand'] != null
                              ? () => svc.unequip(equipped['MainHand']!)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SlotCard(
                          slot: 'OffHand',
                          item: equipped['OffHand'],
                          onTap: () => _pickForSlot(context, ref, svc, 'OffHand', bag),
                          onUnequip: equipped['OffHand'] != null
                              ? () => svc.unequip(equipped['OffHand']!)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Feet
                  _SlotCard(
                    slot: 'Feet',
                    item: equipped['Feet'],
                    onTap: () => _pickForSlot(context, ref, svc, 'Feet', bag),
                    onUnequip: equipped['Feet'] != null
                        ? () => svc.unequip(equipped['Feet']!)
                        : null,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          // ── Total stats summary ────────────────────────────
          _StatsSummary(equipped: equipped),
        ],
      ),
    );
  }

  Future<void> _pickForSlot(
    BuildContext context,
    WidgetRef ref,
    EquipmentService svc,
    String slot,
    List<ItemData> bag,
  ) async {
    final candidates = bag.where((i) => i.equipSlot == slot).toList();
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No $slot items in bag.'),
          backgroundColor: GameColors.bgCard,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    final picked = await showModalBottomSheet<ItemData>(
      context: context,
      backgroundColor: GameColors.bgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        side: BorderSide(color: GameColors.borderSubtle),
      ),
      builder: (_) => _ItemPickerSheet(items: candidates, slotLabel: slot),
    );
    if (picked != null) await svc.equip(picked);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  A single equipment slot card
// ─────────────────────────────────────────────────────────────────────────────
class _SlotCard extends StatelessWidget {
  final String slot;
  final ItemData? item;
  final VoidCallback onTap;
  final VoidCallback? onUnequip;

  const _SlotCard({
    required this.slot,
    required this.item,
    required this.onTap,
    this.onUnequip,
  });

  @override
  Widget build(BuildContext context) {
    final hasItem = item != null;
    final rc = hasItem ? _rarityColor(item!.rarity) : GameColors.borderSubtle;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: hasItem ? rc.withValues(alpha: 0.08) : GameColors.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasItem ? rc.withValues(alpha: 0.7) : GameColors.borderSubtle,
            width: hasItem ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Slot icon
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: hasItem ? rc.withValues(alpha: 0.15) : Colors.black26,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _slotIcon[slot] ?? Icons.help_outline,
                size: 18,
                color: hasItem ? rc : GameColors.textDim,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: hasItem
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item!.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: rc,
                          ),
                        ),
                        Text(
                          '${item!.rarity} ${item!.baseType}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: GameColors.textMuted,
                          ),
                        ),
                        if (item!.minDamage > 0)
                          Text(
                            'DMG ${item!.minDamage}–${item!.maxDamage}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: GameColors.crimsonBlood,
                            ),
                          ),
                        if (item!.armorValue > 0)
                          Text(
                            'ARM ${item!.armorValue}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: GameColors.terminalGreen,
                            ),
                          ),
                      ],
                    )
                  : Text(
                      '${_slotLabel[slot] ?? slot} — Empty',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: GameColors.textDim,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
            ),
            if (hasItem && onUnequip != null)
              GestureDetector(
                onTap: onUnequip,
                child: const Icon(Icons.remove_circle_outline,
                    size: 16, color: GameColors.textDim),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Stats summary row
// ─────────────────────────────────────────────────────────────────────────────
class _StatsSummary extends StatelessWidget {
  final Map<String, ItemData?> equipped;
  const _StatsSummary({required this.equipped});

  @override
  Widget build(BuildContext context) {
    int totalMinDmg = 0, totalMaxDmg = 0, totalArm = 0;
    for (final item in equipped.values) {
      if (item == null) continue;
      totalMinDmg += item.minDamage;
      totalMaxDmg += item.maxDamage;
      totalArm += item.armorValue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: GameColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GameColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MiniStat(label: 'DPS', value: '$totalMinDmg–$totalMaxDmg',
              color: GameColors.crimsonBlood, icon: Icons.flash_on),
          _MiniStat(label: 'ARMOR', value: '$totalArm',
              color: GameColors.terminalGreen, icon: Icons.shield),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _MiniStat({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.jetBrainsMono(fontSize: 9, color: GameColors.textMuted)),
        Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ]),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab 2: Bag view
// ─────────────────────────────────────────────────────────────────────────────
class _BagTab extends ConsumerWidget {
  final List<ItemData> items;
  final Map<String, ItemData?> equipped;
  const _BagTab({required this.items, required this.equipped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.read(equipmentServiceProvider);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'Your bag is empty.',
          style: GoogleFonts.inter(color: GameColors.textDim, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return _BagItemCard(
          item: item,
          equippedInSlot: item.equipSlot != null ? equipped[item.equipSlot] : null,
          onEquip: item.equipSlot != null ? () => svc.equip(item) : null,
        );
      },
    );
  }
}

class _BagItemCard extends StatelessWidget {
  final ItemData item;
  final ItemData? equippedInSlot;
  final VoidCallback? onEquip;
  const _BagItemCard({required this.item, required this.equippedInSlot, this.onEquip});

  @override
  Widget build(BuildContext context) {
    final rc = _rarityColor(item.rarity);
    final canEquip = item.equipSlot != null;

    // Comparison deltas vs currently equipped piece
    final cmp = equippedInSlot;
    final dmgDelta = cmp != null
        ? ((item.minDamage + item.maxDamage) ~/ 2) -
            ((cmp.minDamage + cmp.maxDamage) ~/ 2)
        : null;
    final armDelta = cmp != null ? item.armorValue - cmp.armorValue : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: rc.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: rc.withValues(alpha: 0.4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: rc.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            item.baseType == 'Weapon'
                ? Icons.colorize
                : item.baseType == 'Helm' || item.baseType == 'Head'
                    ? Icons.face_outlined
                    : item.baseType == 'Boots' || item.baseType == 'Feet'
                        ? Icons.directions_walk
                        : item.baseType == 'Gem'
                            ? Icons.diamond_outlined
                            : Icons.shield_outlined,
            size: 20,
            color: rc,
          ),
        ),
        title: Text(
          item.name,
          style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.bold, color: rc),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.rarity} ${item.baseType}${item.equipSlot != null ? " · ${item.equipSlot}" : ""}',
              style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.textMuted),
            ),
            const SizedBox(height: 2),
            Row(children: [
              if (item.minDamage > 0) ...[
                Icon(Icons.flash_on, size: 11, color: GameColors.crimsonBlood),
                Text(
                  ' ${item.minDamage}–${item.maxDamage}',
                  style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.crimsonBlood),
                ),
                const SizedBox(width: 8),
              ],
              if (item.armorValue > 0) ...[
                Icon(Icons.shield, size: 11, color: GameColors.terminalGreen),
                Text(
                  ' ${item.armorValue}',
                  style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.terminalGreen),
                ),
                const SizedBox(width: 8),
              ],
              // Comparison delta
              if (dmgDelta != null && dmgDelta != 0)
                Text(
                  'DMG ${dmgDelta > 0 ? "+" : ""}$dmgDelta',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: dmgDelta > 0 ? GameColors.terminalGreen : GameColors.crimsonBlood),
                ),
              if (armDelta != null && armDelta != 0) ...[
                const SizedBox(width: 4),
                Text(
                  'ARM ${armDelta > 0 ? "+" : ""}$armDelta',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: armDelta > 0 ? GameColors.terminalGreen : GameColors.crimsonBlood),
                ),
              ],
            ]),
          ],
        ),
        trailing: canEquip
            ? TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: rc.withValues(alpha: 0.15),
                  foregroundColor: rc,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: rc.withValues(alpha: 0.5)),
                  ),
                ),
                onPressed: onEquip,
                child: Text('EQUIP', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold)),
              )
            : null,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Item picker sheet (shown when tapping an empty slot)
// ─────────────────────────────────────────────────────────────────────────────
class _ItemPickerSheet extends StatelessWidget {
  final List<ItemData> items;
  final String slotLabel;
  const _ItemPickerSheet({required this.items, required this.slotLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 4),
          width: 36, height: 4,
          decoration: BoxDecoration(
            color: GameColors.borderSubtle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Select $slotLabel item',
            style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const Divider(height: 1, color: GameColors.borderSubtle),
        ...items.map(
          (item) {
            final rc = _rarityColor(item.rarity);
            return ListTile(
              leading: Icon(
                item.baseType == 'Weapon' ? Icons.colorize : Icons.shield_outlined,
                color: rc,
              ),
              title: Text(item.name, style: GoogleFonts.inter(color: rc, fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${item.rarity}  •  DMG ${item.minDamage}–${item.maxDamage}',
                style: GoogleFonts.jetBrainsMono(fontSize: 10, color: GameColors.textMuted),
              ),
              onTap: () => Navigator.pop(context, item),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
