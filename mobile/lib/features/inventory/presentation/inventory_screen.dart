import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vagabond_hero/core/database/app_database.dart';
import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';
import 'package:vagabond_hero/features/inventory/domain/equipment_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Constants & Slot Definitions
// ─────────────────────────────────────────────────────────────────────────────
const _slots = [
  'Head',
  'Neck',
  'Chest',
  'Arms',
  'Waist',
  'Feet',
  'RingL',
  'RingR',
  'MainHand',
  'OffHand',
];

final _slotIcon = {
  'Head': Icons.face_outlined,
  'Neck': Icons.all_inclusive,
  'Chest': Icons.accessibility_new,
  'Arms': Icons.shield,
  'Waist': Icons.horizontal_rule,
  'Feet': Icons.directions_walk,
  'RingL': Icons.radio_button_unchecked,
  'RingR': Icons.radio_button_unchecked,
  'MainHand': Icons.colorize,
  'OffHand': Icons.shield_outlined,
};

final _slotLabel = {
  'Head': 'HEAD',
  'Neck': 'NECK',
  'Chest': 'CHEST / TORSO',
  'Arms': 'ARM / BRACER',
  'Waist': 'WAIST / BELT',
  'Feet': 'FEET / SHOES',
  'RingL': 'L. RING',
  'RingR': 'R. RING',
  'MainHand': 'MAIN HAND',
  'OffHand': 'OFF HAND',
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
//  Main modal widget
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
        // Drag handle
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: GameColors.cyanRune, size: 20),
              const SizedBox(width: 8),
              Text(
                'EQUIPMENT & SATCHEL',
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
            labelStyle: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
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
            loading: () => const Center(
              child: CircularProgressIndicator(color: GameColors.cyanRune),
            ),
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
//  Tab 1: Paper-doll Equipment View
// ─────────────────────────────────────────────────────────────────────────────
class _EquippedTab extends ConsumerWidget {
  final Map<String, ItemData?> equipped;
  final List<ItemData> bag;
  const _EquippedTab({required this.equipped, required this.bag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.read(equipmentServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total stats summary
          _StatsSummary(equipped: equipped),
          const SizedBox(height: 14),

          // ── Paper doll slots ──────────────────────────────
          // Head
          _SlotCard(
            slot: 'Head',
            item: equipped['Head'],
            onTap: () => _pickForSlot(context, ref, svc, 'Head', bag),
            onUnequip: equipped['Head'] != null
                ? () => svc.unequip(equipped['Head']!)
                : null,
          ),
          const SizedBox(height: 6),

          // Neck
          _SlotCard(
            slot: 'Neck',
            item: equipped['Neck'],
            onTap: () => _pickForSlot(context, ref, svc, 'Neck', bag),
            onUnequip: equipped['Neck'] != null
                ? () => svc.unequip(equipped['Neck']!)
                : null,
          ),
          const SizedBox(height: 6),

          // Chest / Torso
          _SlotCard(
            slot: 'Chest',
            item: equipped['Chest'],
            onTap: () => _pickForSlot(context, ref, svc, 'Chest', bag),
            onUnequip: equipped['Chest'] != null
                ? () => svc.unequip(equipped['Chest']!)
                : null,
          ),
          const SizedBox(height: 6),

          // Arms / Bracer & Waist / Belt
          Row(
            children: [
              Expanded(
                child: _SlotCard(
                  slot: 'Arms',
                  item: equipped['Arms'],
                  onTap: () => _pickForSlot(context, ref, svc, 'Arms', bag),
                  onUnequip: equipped['Arms'] != null
                      ? () => svc.unequip(equipped['Arms']!)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SlotCard(
                  slot: 'Waist',
                  item: equipped['Waist'],
                  onTap: () => _pickForSlot(context, ref, svc, 'Waist', bag),
                  onUnequip: equipped['Waist'] != null
                      ? () => svc.unequip(equipped['Waist']!)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Weapons Row: Main Hand & Off Hand
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
          const SizedBox(height: 6),

          // Rings Row: Left Hand Ring & Right Hand Ring
          Row(
            children: [
              Expanded(
                child: _SlotCard(
                  slot: 'RingL',
                  item: equipped['RingL'],
                  onTap: () => _pickForSlot(context, ref, svc, 'RingL', bag),
                  onUnequip: equipped['RingL'] != null
                      ? () => svc.unequip(equipped['RingL']!)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SlotCard(
                  slot: 'RingR',
                  item: equipped['RingR'],
                  onTap: () => _pickForSlot(context, ref, svc, 'RingR', bag),
                  onUnequip: equipped['RingR'] != null
                      ? () => svc.unequip(equipped['RingR']!)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Feet / Shoes
          _SlotCard(
            slot: 'Feet',
            item: equipped['Feet'],
            onTap: () => _pickForSlot(context, ref, svc, 'Feet', bag),
            onUnequip: equipped['Feet'] != null
                ? () => svc.unequip(equipped['Feet']!)
                : null,
          ),
          const SizedBox(height: 12),
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
    // For Ring slots, allow any Ring
    final candidates = bag.where((i) {
      if (slot == 'RingL' || slot == 'RingR') {
        return i.baseType == 'Ring' || i.equipSlot == 'RingL' || i.equipSlot == 'RingR';
      }
      return i.equipSlot == slot || i.baseType == slot;
    }).toList();

    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No ${_slotLabel[slot] ?? slot} items in your bag.'),
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
      builder: (_) => _ItemPickerSheet(items: candidates, slotLabel: _slotLabel[slot] ?? slot),
    );

    if (picked != null) {
      await svc.equip(picked, targetSlot: slot);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Slot Card
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: hasItem ? rc.withValues(alpha: 0.15) : Colors.black26,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _slotIcon[slot] ?? Icons.help_outline,
                size: 16,
                color: hasItem ? rc : GameColors.textDim,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: hasItem
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item!.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: rc,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _slotLabel[slot] ?? slot,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 8.5,
                                  color: GameColors.textMuted,
                                ),
                              ),
                            ),
                            if (item!.minDamage > 0) ...[
                              const SizedBox(width: 4),
                              Text(
                                '${item!.minDamage}-${item!.maxDamage}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  color: GameColors.crimsonBlood,
                                ),
                              ),
                            ],
                            if (item!.armorValue > 0) ...[
                              const SizedBox(width: 4),
                              Text(
                                '+${item!.armorValue}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  color: GameColors.terminalGreen,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    )
                  : Text(
                      '${_slotLabel[slot] ?? slot} — Empty',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        color: GameColors.textDim,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
            ),
            if (hasItem && onUnequip != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onUnequip,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.remove_circle_outline,
                      size: 16, color: GameColors.textDim),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Stats Summary Row
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
          _MiniStat(
            label: 'ATTACK POWER',
            value: '$totalMinDmg–$totalMaxDmg',
            color: GameColors.crimsonBlood,
            icon: Icons.flash_on,
          ),
          _MiniStat(
            label: 'TOTAL ARMOR',
            value: '$totalArm',
            color: GameColors.terminalGreen,
            icon: Icons.shield,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: GameColors.textMuted,
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
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab 2: Bag View
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
          'Your satchel is empty.',
          style: GoogleFonts.inter(
            color: GameColors.textDim,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        final slotKey = item.equipSlot ?? item.baseType;
        final equippedItem = equipped[slotKey] ??
            (item.baseType == 'Ring' ? (equipped['RingL'] ?? equipped['RingR']) : null);

        return _BagItemCard(
          item: item,
          equippedInSlot: equippedItem,
          onEquip: () => svc.equip(item),
        );
      },
    );
  }
}

class _BagItemCard extends StatelessWidget {
  final ItemData item;
  final ItemData? equippedInSlot;
  final VoidCallback? onEquip;
  const _BagItemCard({
    required this.item,
    required this.equippedInSlot,
    this.onEquip,
  });

  @override
  Widget build(BuildContext context) {
    final rc = _rarityColor(item.rarity);
    final canEquip = item.equipSlot != null ||
        item.baseType == 'Weapon' ||
        item.baseType == 'Chest' ||
        item.baseType == 'Head' ||
        item.baseType == 'Neck' ||
        item.baseType == 'Arms' ||
        item.baseType == 'Waist' ||
        item.baseType == 'Feet' ||
        item.baseType == 'Ring';

    // Comparison deltas vs currently equipped piece
    final cmp = equippedInSlot;
    final dmgDelta = cmp != null
        ? ((item.minDamage + item.maxDamage) ~/ 2) -
            ((cmp.minDamage + cmp.maxDamage) ~/ 2)
        : null;
    final armDelta = cmp != null ? item.armorValue - cmp.armorValue : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: rc.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: rc.withValues(alpha: 0.4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: rc.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            _slotIcon[item.equipSlot] ??
                (item.baseType == 'Weapon'
                    ? Icons.colorize
                    : item.baseType == 'Ring'
                        ? Icons.radio_button_unchecked
                        : Icons.shield_outlined),
            size: 20,
            color: rc,
          ),
        ),
        title: Text(
          item.name,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: rc,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.rarity} ${item.baseType}${item.equipSlot != null ? " · ${_slotLabel[item.equipSlot] ?? item.equipSlot}" : ""}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: GameColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                if (item.minDamage > 0) ...[
                  const Icon(Icons.flash_on, size: 11, color: GameColors.crimsonBlood),
                  Text(
                    ' ${item.minDamage}–${item.maxDamage}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: GameColors.crimsonBlood,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (item.armorValue > 0) ...[
                  const Icon(Icons.shield, size: 11, color: GameColors.terminalGreen),
                  Text(
                    ' ${item.armorValue}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: GameColors.terminalGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // Comparison delta
                if (dmgDelta != null && dmgDelta != 0)
                  Text(
                    'DMG ${dmgDelta > 0 ? "+" : ""}$dmgDelta',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: dmgDelta > 0
                          ? GameColors.terminalGreen
                          : GameColors.crimsonBlood,
                    ),
                  ),
                if (armDelta != null && armDelta != 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    'ARM ${armDelta > 0 ? "+" : ""}$armDelta',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: armDelta > 0
                          ? GameColors.terminalGreen
                          : GameColors.crimsonBlood,
                    ),
                  ),
                ],
              ],
            ),
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
                child: Text(
                  'EQUIP',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Item Picker Sheet
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
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: GameColors.borderSubtle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Select $slotLabel item',
            style: GoogleFonts.cinzel(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const Divider(height: 1, color: GameColors.borderSubtle),
        ...items.map(
          (item) {
            final rc = _rarityColor(item.rarity);
            return ListTile(
              leading: Icon(
                _slotIcon[item.equipSlot] ??
                    (item.baseType == 'Weapon'
                        ? Icons.colorize
                        : item.baseType == 'Ring'
                            ? Icons.radio_button_unchecked
                            : Icons.shield_outlined),
                color: rc,
              ),
              title: Text(
                item.name,
                style: GoogleFonts.inter(
                  color: rc,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${item.rarity} ${item.baseType}'
                '${item.minDamage > 0 ? " • DMG ${item.minDamage}–${item.maxDamage}" : ""}'
                '${item.armorValue > 0 ? " • ARM ${item.armorValue}" : ""}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: GameColors.textMuted,
                ),
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
