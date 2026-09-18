import 'dart:convert';
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

String resolveCanonicalSlot(ItemData item) {
  final slot = item.equipSlot;
  if (slot != null && _slots.contains(slot)) return slot;
  final base = item.baseType;
  switch (base) {
    case 'Head':
    case 'Neck':
    case 'Chest':
    case 'Arms':
    case 'Waist':
    case 'Feet':
    case 'Ring':
      return base;
    case 'Weapon':
      return 'MainHand';
    case 'Shield':
      return 'OffHand';
    default:
      return slot ?? base;
  }
}

Color _rarityColor(String rarity) => GameColors.forRarity(rarity);

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
    _tab = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(playerInventoryProvider);
    final safeItemsAsync = ref.watch(playerSafeStashProvider);
    final playerAsync = ref.watch(playerStreamProvider);
    final currentRoomId = playerAsync.value?.currentRoomId ?? 101;
    final isSanctuary = currentRoomId == 101 ||
        (currentRoomId >= 301 && currentRoomId <= 304) ||
        (currentRoomId >= 2201 && currentRoomId <= 2204);

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
              if (isSanctuary)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: GameColors.cyanRune.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: GameColors.cyanRune.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, size: 11, color: GameColors.cyanRune),
                      const SizedBox(width: 4),
                      Text(
                        'SANCTUARY SAFE ACTIVE',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: GameColors.cyanRune,
                        ),
                      ),
                    ],
                  ),
                ),
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
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: GameColors.cyanRune,
            labelColor: GameColors.cyanRune,
            unselectedLabelColor: GameColors.textMuted,
            labelStyle: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: '⚔ EQUIP'),
              Tab(text: '🎒 GEAR'),
              Tab(text: '🧪 POTIONS'),
              Tab(text: '💎 GEMS'),
              Tab(text: '🔒 SAFE'),
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
              final consumables = items
                  .where((i) =>
                      !i.isEquipped &&
                      (i.baseType == 'Potion' ||
                          i.baseType == 'Consumable' ||
                          i.baseType == 'Food' ||
                          i.baseType == 'Scroll'))
                  .toList();
              final gearBag = items
                  .where((i) =>
                      !i.isEquipped &&
                      i.baseType != 'Gem' &&
                      i.baseType != 'Potion' &&
                      i.baseType != 'Consumable' &&
                      i.baseType != 'Food' &&
                      i.baseType != 'Scroll')
                  .toList();
              final gems = items.where((i) => i.baseType == 'Gem').toList();
              final safeItems = safeItemsAsync.value ?? [];

              return TabBarView(
                controller: _tab,
                children: [
                  _EquippedTab(equipped: equipped, bag: gearBag),
                  _BagTab(items: gearBag, equipped: equipped, isSanctuary: isSanctuary),
                  _ConsumablesTab(items: consumables, isSanctuary: isSanctuary),
                  _GemsTab(items: gems, isSanctuary: isSanctuary),
                  _SafeStashTab(items: safeItems, isSanctuary: isSanctuary),
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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total stats summary
          _StatsSummary(equipped: equipped),
          const SizedBox(height: 12),

          // ── Paper doll slots ──────────────────────────────
          // Head
          _SlotCard(
            slot: 'Head',
            item: equipped['Head'],
            onTap: () => _handleSlotTap(context, ref, svc, 'Head', equipped['Head'], bag),
            onUnequip: equipped['Head'] != null
                ? () => svc.unequip(equipped['Head']!)
                : null,
          ),
          const SizedBox(height: 6),

          // Neck
          _SlotCard(
            slot: 'Neck',
            item: equipped['Neck'],
            onTap: () => _handleSlotTap(context, ref, svc, 'Neck', equipped['Neck'], bag),
            onUnequip: equipped['Neck'] != null
                ? () => svc.unequip(equipped['Neck']!)
                : null,
          ),
          const SizedBox(height: 6),

          // Chest / Torso
          _SlotCard(
            slot: 'Chest',
            item: equipped['Chest'],
            onTap: () => _handleSlotTap(context, ref, svc, 'Chest', equipped['Chest'], bag),
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
                  onTap: () => _handleSlotTap(context, ref, svc, 'Arms', equipped['Arms'], bag),
                  onUnequip: equipped['Arms'] != null
                      ? () => svc.unequip(equipped['Arms']!)
                      : null,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _SlotCard(
                  slot: 'Waist',
                  item: equipped['Waist'],
                  onTap: () => _handleSlotTap(context, ref, svc, 'Waist', equipped['Waist'], bag),
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
                  onTap: () => _handleSlotTap(context, ref, svc, 'MainHand', equipped['MainHand'], bag),
                  onUnequip: equipped['MainHand'] != null
                      ? () => svc.unequip(equipped['MainHand']!)
                      : null,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _SlotCard(
                  slot: 'OffHand',
                  item: equipped['OffHand'],
                  onTap: () => _handleSlotTap(context, ref, svc, 'OffHand', equipped['OffHand'], bag),
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
                  onTap: () => _handleSlotTap(context, ref, svc, 'RingL', equipped['RingL'], bag),
                  onUnequip: equipped['RingL'] != null
                      ? () => svc.unequip(equipped['RingL']!)
                      : null,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _SlotCard(
                  slot: 'RingR',
                  item: equipped['RingR'],
                  onTap: () => _handleSlotTap(context, ref, svc, 'RingR', equipped['RingR'], bag),
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
            onTap: () => _handleSlotTap(context, ref, svc, 'Feet', equipped['Feet'], bag),
            onUnequip: equipped['Feet'] != null
                ? () => svc.unequip(equipped['Feet']!)
                : null,
          ),
        ],
      ),
    );
  }

  void _handleSlotTap(
    BuildContext context,
    WidgetRef ref,
    EquipmentService svc,
    String slot,
    ItemData? item,
    List<ItemData> bag,
  ) {
    if (item != null) {
      // Show rich item detail modal with unequip action
      showItemDetailModal(
        context: context,
        item: item,
        isEquipped: true,
        onAction: () => svc.unequip(item),
      );
    } else {
      // Pick item to equip into this empty slot
      _pickForSlot(context, ref, svc, slot, bag);
    }
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
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: hasItem ? rc.withValues(alpha: 0.15) : Colors.black26,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _slotIcon[slot] ?? Icons.help_outline,
                size: 15,
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
                        const SizedBox(height: 1),
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
            if (hasItem) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: 'Inspect item details',
                child: GestureDetector(
                  onTap: onTap,
                  child: const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(Icons.info_outline,
                        size: 16, color: GameColors.cyanRune),
                  ),
                ),
              ),
              if (onUnequip != null) ...[
                const SizedBox(width: 2),
                Tooltip(
                  message: 'Unequip item',
                  child: GestureDetector(
                    onTap: onUnequip,
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.remove_circle_outline,
                          size: 16, color: GameColors.textDim),
                    ),
                  ),
                ),
              ],
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
class _BagTab extends ConsumerStatefulWidget {
  final List<ItemData> items;
  final Map<String, ItemData?> equipped;
  final bool isSanctuary;
  const _BagTab({
    required this.items,
    required this.equipped,
    required this.isSanctuary,
  });

  @override
  ConsumerState<_BagTab> createState() => _BagTabState();
}

class _BagTabState extends ConsumerState<_BagTab> {
  String _filterSlot = 'ALL';

  @override
  Widget build(BuildContext context) {
    final svc = ref.read(equipmentServiceProvider);

    if (widget.items.isEmpty) {
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

    final filteredItems = widget.items.where((item) {
      if (_filterSlot == 'ALL') return true;
      final slot = resolveCanonicalSlot(item);
      if (_filterSlot == 'Ring') {
        return slot == 'Ring' || slot == 'RingL' || slot == 'RingR';
      }
      return slot == _filterSlot;
    }).toList();

    const filterOptions = [
      {'key': 'ALL', 'label': 'ALL'},
      {'key': 'MainHand', 'label': 'WEAPON'},
      {'key': 'OffHand', 'label': 'OFF HAND'},
      {'key': 'Head', 'label': 'HEAD'},
      {'key': 'Neck', 'label': 'NECK'},
      {'key': 'Chest', 'label': 'TORSO'},
      {'key': 'Arms', 'label': 'ARMS'},
      {'key': 'Waist', 'label': 'WAIST'},
      {'key': 'Feet', 'label': 'FEET'},
      {'key': 'Ring', 'label': 'RINGS'},
    ];

    return Column(
      children: [
        // Slot Quick-Filter Chips Bar
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: GameColors.bgPrimary.withValues(alpha: 0.6),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filterOptions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, idx) {
              final opt = filterOptions[idx];
              final key = opt['key']!;
              final isSelected = _filterSlot == key;
              final icon = key == 'ALL'
                  ? Icons.all_inbox
                  : key == 'Ring'
                      ? Icons.radio_button_unchecked
                      : (_slotIcon[key] ?? Icons.category);

              return ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  icon,
                  size: 13,
                  color: isSelected ? Colors.black : GameColors.textMuted,
                ),
                label: Text(
                  opt['label']!,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : GameColors.textMuted,
                  ),
                ),
                selected: isSelected,
                selectedColor: GameColors.cyanRune,
                backgroundColor: GameColors.bgCard,
                side: BorderSide(
                  color: isSelected
                      ? GameColors.cyanRune
                      : GameColors.borderSubtle,
                  width: 1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                onSelected: (_) {
                  setState(() {
                    _filterSlot = key;
                  });
                },
              );
            },
          ),
        ),
        const Divider(height: 1, color: GameColors.borderSubtle),

        // Filtered Item List
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_off, size: 36, color: GameColors.textDim),
                      const SizedBox(height: 8),
                      Text(
                        'No $_filterSlot equipment in satchel.',
                        style: GoogleFonts.inter(
                          color: GameColors.textDim,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                  itemCount: filteredItems.length,
                  itemBuilder: (_, i) {
                    final item = filteredItems[i];
                    final slotKey = resolveCanonicalSlot(item);
                    final equippedItem = widget.equipped[slotKey] ??
                        (slotKey == 'Ring' || item.baseType == 'Ring'
                            ? (widget.equipped['RingL'] ?? widget.equipped['RingR'])
                            : null);

                    return _BagItemCard(
                      item: item,
                      equippedInSlot: equippedItem,
                      isSanctuary: widget.isSanctuary,
                      onEquip: () => svc.equip(item),
                      onDepositSafe: widget.isSanctuary ? () => svc.depositToSafe(item) : null,
                      onDrop: () async {
                        await svc.dropItem(item);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Dropped ${item.name} to the ground.', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                              backgroundColor: const Color(0xFF0F243A),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _BagItemCard extends StatelessWidget {
  final ItemData item;
  final ItemData? equippedInSlot;
  final bool isSanctuary;
  final VoidCallback? onEquip;
  final VoidCallback? onDepositSafe;
  final VoidCallback? onDrop;
  const _BagItemCard({
    required this.item,
    required this.equippedInSlot,
    required this.isSanctuary,
    this.onEquip,
    this.onDepositSafe,
    this.onDrop,
  });

  Map<String, dynamic> _parseMetadata(ItemData d) {
    try {
      if (d.modifiersJson.trim().isNotEmpty) {
        final decoded = jsonDecode(d.modifiersJson);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
    } catch (_) {}
    return {};
  }

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

    final canonicalSlot = resolveCanonicalSlot(item);
    final slotLabel = _slotLabel[canonicalSlot] ?? _slotLabel[item.equipSlot] ?? item.baseType.toUpperCase();
    final slotIcon = _slotIcon[canonicalSlot] ?? _slotIcon[item.equipSlot] ?? Icons.shield_outlined;

    // Parse baseStats from item and equipped piece
    final itemMeta = _parseMetadata(item);
    final itemBs = (itemMeta['baseStats'] as Map<String, dynamic>?) ?? {};
    final itemSta = (itemBs['STA'] as num?)?.toInt() ?? 0;
    final itemStr = (itemBs['STR'] as num?)?.toInt() ?? 0;
    final itemAgi = (itemBs['AGI'] as num?)?.toInt() ?? 0;
    final itemInt = (itemBs['INT'] as num?)?.toInt() ?? 0;

    final cmp = equippedInSlot;
    final cmpMeta = cmp != null ? _parseMetadata(cmp) : <String, dynamic>{};
    final cmpBs = (cmpMeta['baseStats'] as Map<String, dynamic>?) ?? {};
    final cmpSta = (cmpBs['STA'] as num?)?.toInt() ?? 0;
    final cmpStr = (cmpBs['STR'] as num?)?.toInt() ?? 0;
    final cmpAgi = (cmpBs['AGI'] as num?)?.toInt() ?? 0;
    final cmpInt = (cmpBs['INT'] as num?)?.toInt() ?? 0;

    // Stat deltas
    final dmgDelta = cmp != null
        ? ((item.minDamage + item.maxDamage) ~/ 2) -
            ((cmp.minDamage + cmp.maxDamage) ~/ 2)
        : (item.minDamage > 0 || item.maxDamage > 0
            ? ((item.minDamage + item.maxDamage) ~/ 2)
            : null);

    // Total armor delta = gear armor difference + STA armor difference (1 ARM per 4 STA)
    final itemTotalArm = item.armorValue + (itemSta ~/ 4);
    final cmpTotalArm = cmp != null ? (cmp.armorValue + (cmpSta ~/ 4)) : 0;
    final armDelta = cmp != null ? (itemTotalArm - cmpTotalArm) : (item.armorValue > 0 ? item.armorValue : null);

    // HP delta = 10 Max HP per STA
    final hpDelta = cmp != null ? ((itemSta - cmpSta) * 10) : (itemSta > 0 ? itemSta * 10 : null);

    final staDelta = cmp != null ? (itemSta - cmpSta) : (itemSta > 0 ? itemSta : null);
    final strDelta = cmp != null ? (itemStr - cmpStr) : (itemStr > 0 ? itemStr : null);
    final agiDelta = cmp != null ? (itemAgi - cmpAgi) : (itemAgi > 0 ? itemAgi : null);
    final intDelta = cmp != null ? (itemInt - cmpInt) : (itemInt > 0 ? itemInt : null);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: rc.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: rc.withValues(alpha: 0.4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () {
            showItemDetailModal(
              context: context,
              item: item,
              isEquipped: false,
              equippedComparison: cmp,
              onAction: onEquip ?? () {},
              onDrop: onDrop,
            );
          },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: rc.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            slotIcon,
            size: 20,
            color: rc,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: rc,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: GameColors.bgPrimary,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: GameColors.borderSubtle),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(slotIcon, size: 9, color: GameColors.cyanRune),
                  const SizedBox(width: 3),
                  Text(
                    slotLabel,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: GameColors.cyanRune,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Text(
              '${item.rarity} ${item.baseType}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9.5,
                color: GameColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            // Primary weapon/armor stat line
            Row(
              children: [
                if (item.minDamage > 0) ...[
                  const Icon(Icons.flash_on, size: 11, color: GameColors.crimsonBlood),
                  Text(
                    ' ${item.minDamage}–${item.maxDamage}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: GameColors.crimsonBlood,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (item.armorValue > 0) ...[
                  const Icon(Icons.shield, size: 11, color: GameColors.terminalGreen),
                  Text(
                    ' +${item.armorValue}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: GameColors.terminalGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 4),
            // Comparison Stat Pills (Green = Positive, Red = Negative)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (dmgDelta != null && dmgDelta != 0)
                  _StatDeltaPill(label: 'DMG', delta: dmgDelta),
                if (armDelta != null && armDelta != 0)
                  _StatDeltaPill(label: 'ARM', delta: armDelta),
                if (hpDelta != null && hpDelta != 0)
                  _StatDeltaPill(label: 'HP', delta: hpDelta),
                if (staDelta != null && staDelta != 0)
                  _StatDeltaPill(label: 'STA', delta: staDelta),
                if (strDelta != null && strDelta != 0)
                  _StatDeltaPill(label: 'STR', delta: strDelta),
                if (agiDelta != null && agiDelta != 0)
                  _StatDeltaPill(label: 'AGI', delta: agiDelta),
                if (intDelta != null && intDelta != 0)
                  _StatDeltaPill(label: 'INT', delta: intDelta),
              ],
            ),
            // Equipped Reference Bar
            if (cmp != null) ...[
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                decoration: BoxDecoration(
                  color: GameColors.bgPrimary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: GameColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.compare_arrows, size: 11, color: GameColors.cyanRune),
                    const SizedBox(width: 4),
                    Text(
                      'Equipped: ',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        color: GameColors.textDim,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${cmp.name} (${cmp.rarity})',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: _rarityColor(cmp.rarity),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (canEquip) ...[
              const SizedBox(height: 4),
              Text(
                '• Slot is currently empty',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: GameColors.textDim,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Inspect item details & lore',
              child: IconButton(
                icon: const Icon(Icons.info_outline, size: 18, color: GameColors.cyanRune),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(),
                onPressed: () {
                  showItemDetailModal(
                    context: context,
                    item: item,
                    isEquipped: false,
                    equippedComparison: cmp,
                    onAction: onEquip ?? () {},
                    onDrop: onDrop,
                  );
                },
              ),
            ),
            const SizedBox(width: 2),
            if (isSanctuary && onDepositSafe != null) ...[
              Tooltip(
                message: 'Deposit to Town Safe (Immune to Death Drop)',
                child: IconButton(
                  icon: const Icon(Icons.archive_outlined, size: 18, color: GameColors.cyanRune),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(),
                  onPressed: onDepositSafe,
                ),
              ),
              const SizedBox(width: 4),
            ],
            if (onDrop != null) ...[
              Tooltip(
                message: 'Drop onto ground',
                child: IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 18, color: GameColors.textDim),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(),
                  onPressed: onDrop,
                ),
              ),
              const SizedBox(width: 4),
            ],
            if (canEquip)
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: rc.withValues(alpha: 0.15),
                  foregroundColor: rc,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              ),
          ],
        ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Stat Delta Badge (Green for positive, Red for negative)
// ─────────────────────────────────────────────────────────────────────────────
class _StatDeltaPill extends StatelessWidget {
  final String label;
  final int delta;
  const _StatDeltaPill({required this.label, required this.delta});

  @override
  Widget build(BuildContext context) {
    final isPos = delta > 0;
    final color = isPos ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final sign = isPos ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Text(
        '$sign$delta $label',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab 3: Gems Bag View
// ─────────────────────────────────────────────────────────────────────────────
class _GemsTab extends ConsumerWidget {
  final List<ItemData> items;
  final bool isSanctuary;
  const _GemsTab({required this.items, required this.isSanctuary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.read(equipmentServiceProvider);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.diamond_outlined, size: 40, color: GameColors.textDim),
            const SizedBox(height: 8),
            Text(
              'No gems found in satchel.\nDefeat rare enemies or find caches to discover socketable gems.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: GameColors.textDim,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final gem = items[i];
        final rc = _rarityColor(gem.rarity);

        Map<String, dynamic> meta = {};
        try {
          if (gem.modifiersJson.trim().isNotEmpty) {
            final decoded = jsonDecode(gem.modifiersJson);
            if (decoded is Map<String, dynamic>) meta = decoded;
          }
        } catch (_) {}

        final socketType = meta['socketType'] as String? ?? 'Socketable Gem';
        final wBonus = meta['socketBonusWeapon'] as String? ?? '';
        final aBonus = meta['socketBonusArmor'] as String? ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: rc.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: rc.withValues(alpha: 0.5)),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () {
                showItemDetailModal(
                  context: ctx,
                  item: gem,
                  isEquipped: false,
                  onAction: () {},
                  onDrop: () async {
                    await svc.dropItem(gem);
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text('Dropped ${gem.name} to the ground.', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                          backgroundColor: const Color(0xFF0F243A),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: rc.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: rc.withValues(alpha: 0.6)),
                ),
                child: Icon(Icons.diamond, size: 20, color: rc),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      gem.name,
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: rc,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: rc.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      gem.rarity.toUpperCase(),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        color: rc,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    socketType,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9.5,
                      color: GameColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (wBonus.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.flash_on, size: 10, color: GameColors.crimsonBlood),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Weapon: $wBonus',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              color: GameColors.textDim,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (aBonus.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.shield, size: 10, color: GameColors.terminalGreen),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Armor: $aBonus',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              color: GameColors.textDim,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'Inspect gem details & socket bonuses',
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, size: 18, color: GameColors.cyanRune),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        showItemDetailModal(
                          context: ctx,
                          item: gem,
                          isEquipped: false,
                          onAction: () {},
                          onDrop: () async {
                            await svc.dropItem(gem);
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('Dropped ${gem.name} to the ground.', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                                  backgroundColor: const Color(0xFF0F243A),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 2),
                  if (isSanctuary)
                    Tooltip(
                      message: 'Store Gem in Town Safe',
                      child: IconButton(
                        icon: const Icon(Icons.archive_outlined, size: 18, color: GameColors.cyanRune),
                        onPressed: () => svc.depositToSafe(gem),
                      ),
                    ),
                  Tooltip(
                    message: 'Drop Gem to Ground',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_downward, size: 18, color: GameColors.textDim),
                      onPressed: () async {
                        await svc.dropItem(gem);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text('Dropped ${gem.name} to the ground.', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                              backgroundColor: const Color(0xFF0F243A),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab 3: Consumables & Potions Bag View
// ─────────────────────────────────────────────────────────────────────────────
class _ConsumablesTab extends ConsumerWidget {
  final List<ItemData> items;
  final bool isSanctuary;
  const _ConsumablesTab({required this.items, required this.isSanctuary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.read(equipmentServiceProvider);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.science_outlined, size: 40, color: GameColors.textDim),
            const SizedBox(height: 8),
            Text(
              'No potions or consumables in satchel.\nDefeat monsters or visit town merchants to replenish your supplies.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: GameColors.textDim,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final potion = items[i];
        final rc = _rarityColor(potion.rarity);

        Map<String, dynamic> meta = {};
        try {
          if (potion.modifiersJson.trim().isNotEmpty) {
            final decoded = jsonDecode(potion.modifiersJson);
            if (decoded is Map<String, dynamic>) meta = decoded;
          }
        } catch (_) {}

        final healAmount = meta['healAmount'] as num? ?? 35;
        final desc = meta['description'] as String? ?? 'A potent restorative draught.';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: rc.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: rc.withValues(alpha: 0.4)),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () {
                showItemDetailModal(
                  context: ctx,
                  item: potion,
                  isEquipped: false,
                  onAction: () async {
                    final msg = await svc.useConsumable(potion);
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(msg, style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                          backgroundColor: const Color(0xFF0F243A),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  onDrop: () async {
                    await svc.dropItem(potion);
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text('Dropped ${potion.name} to the ground.', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                          backgroundColor: const Color(0xFF0F243A),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.6)),
                ),
                child: const Icon(Icons.science, size: 20, color: Color(0xFF10B981)),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      potion.name,
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: rc,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '+$healAmount HP',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: GameColors.textMuted,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'Inspect item details & lore',
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, size: 18, color: GameColors.cyanRune),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        showItemDetailModal(
                          context: ctx,
                          item: potion,
                          isEquipped: false,
                          onAction: () async {
                            final msg = await svc.useConsumable(potion);
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(msg, style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                                  backgroundColor: const Color(0xFF0F243A),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          onDrop: () async {
                            await svc.dropItem(potion);
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('Dropped ${potion.name} to the ground.', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                                  backgroundColor: const Color(0xFF0F243A),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 2),
                  if (isSanctuary) ...[
                    Tooltip(
                      message: 'Store in Town Safe',
                      child: IconButton(
                        icon: const Icon(Icons.archive_outlined, size: 18, color: GameColors.cyanRune),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        constraints: const BoxConstraints(),
                        onPressed: () => svc.depositToSafe(potion),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Tooltip(
                    message: 'Drop onto ground',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_downward, size: 18, color: GameColors.textDim),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await svc.dropItem(potion);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text('Dropped ${potion.name} to the ground.', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                              backgroundColor: const Color(0xFF0F243A),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.2),
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(color: Color(0xFF10B981), width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () async {
                      final msg = await svc.useConsumable(potion);
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text(msg, style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                            backgroundColor: const Color(0xFF0F243A),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'USE',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tab 5: Safe Stash View (Sanctuary Storage - Immune to Death Drop)
// ─────────────────────────────────────────────────────────────────────────────
class _SafeStashTab extends ConsumerWidget {
  final List<ItemData> items;
  final bool isSanctuary;
  const _SafeStashTab({required this.items, required this.isSanctuary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.read(equipmentServiceProvider);

    return Column(
      children: [
        // Security Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0F243A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: GameColors.cyanRune.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_user, color: GameColors.cyanRune, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOWN SAFE STASH (PROTECTED)',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: GameColors.cyanRune,
                      ),
                    ),
                    Text(
                      'Items stored here will NEVER drop on death.',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: GameColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${items.length} STORED',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: GameColors.goldAccent,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_open_outlined, size: 42, color: GameColors.textDim),
                      const SizedBox(height: 8),
                      Text(
                        'Town Safe is empty.',
                        style: GoogleFonts.inter(
                          color: GameColors.textDim,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Switch to BAG or GEMS and tap the archive icon [📥]\nto deposit equipment you want to protect from death loss.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: GameColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    final rc = _rarityColor(item.rarity);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: GameColors.bgCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: GameColors.cyanRune.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: rc.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: rc.withValues(alpha: 0.5)),
                          ),
                          child: Icon(
                            item.baseType == 'Gem' ? Icons.diamond : Icons.shield_outlined,
                            size: 18,
                            color: rc,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: rc,
                          ),
                        ),
                        subtitle: Text(
                          '${item.rarity} ${item.baseType}',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9.5,
                            color: GameColors.textMuted,
                          ),
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GameColors.cyanRune.withValues(alpha: 0.15),
                            foregroundColor: GameColors.cyanRune,
                            side: BorderSide(color: GameColors.cyanRune.withValues(alpha: 0.6)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(Icons.unarchive_outlined, size: 14),
                          label: Text(
                            'WITHDRAW',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => svc.withdrawFromSafe(item),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
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

// ─────────────────────────────────────────────────────────────────────────────
//  Rich Item Detail Sheet
// ─────────────────────────────────────────────────────────────────────────────
void showItemDetailModal({
  required BuildContext context,
  required ItemData item,
  required bool isEquipped,
  required VoidCallback onAction,
  VoidCallback? onDrop,
  ItemData? equippedComparison,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: GameColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      side: BorderSide(color: GameColors.borderSubtle),
    ),
    builder: (ctx) => FractionallySizedBox(
      heightFactor: 0.88,
      child: _ItemDetailSheet(
        item: item,
        isEquipped: isEquipped,
        onAction: onAction,
        onDrop: onDrop,
        equippedComparison: equippedComparison,
      ),
    ),
  );
}

class _ItemDetailSheet extends StatelessWidget {
  final ItemData item;
  final bool isEquipped;
  final VoidCallback onAction;
  final VoidCallback? onDrop;
  final ItemData? equippedComparison;

  const _ItemDetailSheet({
    required this.item,
    required this.isEquipped,
    required this.onAction,
    this.onDrop,
    this.equippedComparison,
  });

  Map<String, dynamic> _parseMetadata() {
    try {
      if (item.modifiersJson.trim().isNotEmpty) {
        final decoded = jsonDecode(item.modifiersJson);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
    } catch (_) {}
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final rc = _rarityColor(item.rarity);
    final meta = _parseMetadata();

    final desc = meta['description'] as String? ??
        'An artefact found amidst the shattered ruins of the old world.';
    final baseStats = meta['baseStats'] as Map<String, dynamic>? ?? {};
    final buffs = (meta['buffs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final statRolls = (meta['statRolls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final uniqueTrait = meta['uniqueTrait'] as String?;
    final otherModifiers = (meta['otherModifiers'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final setInfo = meta['set'] as Map<String, dynamic>?;
    final glitchInfo = meta['glitch'] as Map<String, dynamic>?;
    final socketType = meta['socketType'] as String?;
    final socketBonusWeapon = meta['socketBonusWeapon'] as String?;
    final socketBonusArmor = meta['socketBonusArmor'] as String?;
    final healAmount = meta['healAmount'] as num?;

    final slotName = _slotLabel[item.equipSlot] ?? item.equipSlot ?? item.baseType.toUpperCase();

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

              // Scrollable content
              Expanded(
                child: ListView(
                  children: [
                    // Header card with glowing rarity border
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: rc.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: rc.withValues(alpha: 0.6), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: rc.withValues(alpha: 0.15),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon & Socket Indicator
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: rc.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: rc),
                                ),
                                child: Icon(
                                  _slotIcon[item.equipSlot] ??
                                      (item.baseType == 'Weapon'
                                          ? Icons.colorize
                                          : item.baseType == 'Ring'
                                              ? Icons.radio_button_unchecked
                                              : Icons.shield_outlined),
                                  size: 28,
                                  color: rc,
                                ),
                              ),
                              if (item.socketCount > 0)
                                Positioned(
                                  bottom: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: GameColors.bgPrimary,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: GameColors.cyanRune, width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        item.socketCount,
                                        (i) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: GameColors.cyanRune, width: 1),
                                            color: GameColors.bgSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Name, Rarity, Slot badges
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.cinzel(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: rc,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: rc.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.rarity.toUpperCase(),
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.bold,
                                          color: rc,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '•  $slotName',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 9.5,
                                        color: GameColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: isEquipped
                                        ? GameColors.terminalGreen.withValues(alpha: 0.15)
                                        : Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isEquipped
                                          ? GameColors.terminalGreen.withValues(alpha: 0.6)
                                          : GameColors.borderSubtle,
                                    ),
                                  ),
                                  child: Text(
                                    isEquipped ? '✓ EQUIPPED IN SLOT' : '🎒 IN SATCHEL',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: isEquipped
                                          ? GameColors.terminalGreen
                                          : GameColors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Lore Description
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: GameColors.bgCard.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: GameColors.borderSubtle),
                      ),
                      child: Text(
                        '"$desc"',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: GameColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Equipped Comparison Card (When viewing satchel gear)
                    if (!isEquipped && equippedComparison != null) ...[
                      _SectionHeader(
                        title: 'VS. CURRENTLY EQUIPPED',
                        icon: Icons.compare_arrows,
                        color: GameColors.cyanRune,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GameColors.bgSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GameColors.cyanRune.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: _rarityColor(equippedComparison!.rarity).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    _slotIcon[resolveCanonicalSlot(equippedComparison!)] ?? Icons.shield,
                                    size: 16,
                                    color: _rarityColor(equippedComparison!.rarity),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        equippedComparison!.name,
                                        style: GoogleFonts.cinzel(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: _rarityColor(equippedComparison!.rarity),
                                        ),
                                      ),
                                      Text(
                                        '${equippedComparison!.rarity} ${_slotLabel[resolveCanonicalSlot(equippedComparison!)] ?? equippedComparison!.baseType}',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 9,
                                          color: GameColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(height: 1, color: GameColors.borderSubtle),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'EQUIPPED DMG',
                                      style: GoogleFonts.jetBrainsMono(fontSize: 8.5, color: GameColors.textDim),
                                    ),
                                    Text(
                                      equippedComparison!.minDamage > 0
                                          ? '${equippedComparison!.minDamage}–${equippedComparison!.maxDamage}'
                                          : '—',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: GameColors.textMain,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(width: 1, height: 24, color: GameColors.borderSubtle),
                                Column(
                                  children: [
                                    Text(
                                      'EQUIPPED ARM',
                                      style: GoogleFonts.jetBrainsMono(fontSize: 8.5, color: GameColors.textDim),
                                    ),
                                    Text(
                                      equippedComparison!.armorValue > 0
                                          ? '+${equippedComparison!.armorValue}'
                                          : '—',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: GameColors.textMain,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(width: 1, height: 24, color: GameColors.borderSubtle),
                                Column(
                                  children: [
                                    Text(
                                      'NET CHANGE',
                                      style: GoogleFonts.jetBrainsMono(fontSize: 8.5, color: GameColors.cyanRune),
                                    ),
                                    Builder(
                                      builder: (_) {
                                        final dmgDiff = ((item.minDamage + item.maxDamage) ~/ 2) -
                                            ((equippedComparison!.minDamage + equippedComparison!.maxDamage) ~/ 2);
                                        final armDiff = item.armorValue - equippedComparison!.armorValue;
                                        final isUpgrade = dmgDiff > 0 || armDiff > 0;
                                        final isDowngrade = dmgDiff < 0 || armDiff < 0;
                                        final text = dmgDiff != 0
                                            ? '${dmgDiff > 0 ? "+" : ""}$dmgDiff DMG'
                                            : armDiff != 0
                                                ? '${armDiff > 0 ? "+" : ""}$armDiff ARM'
                                                : 'EQUAL';
                                        final color = isUpgrade
                                            ? const Color(0xFF10B981)
                                            : isDowngrade
                                                ? const Color(0xFFEF4444)
                                                : GameColors.textDim;
                                        return Text(
                                          text,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: color,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Primary Combat Power (Attack, Armor, Sockets)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: GameColors.bgCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: GameColors.borderSubtle),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _DetailCombatStat(
                            icon: Icons.flash_on,
                            label: 'ATTACK POWER',
                            value: item.minDamage > 0
                                ? '${item.minDamage} – ${item.maxDamage}'
                                : '—',
                            color: GameColors.crimsonBlood,
                          ),
                          Container(width: 1, height: 32, color: GameColors.borderSubtle),
                          _DetailCombatStat(
                            icon: Icons.shield,
                            label: 'ARMOR VALUE',
                            value: item.armorValue > 0 ? '+${item.armorValue}' : '—',
                            color: GameColors.terminalGreen,
                          ),
                          Container(width: 1, height: 32, color: GameColors.borderSubtle),
                          _DetailCombatStat(
                            icon: Icons.adjust,
                            label: 'SOCKETS',
                            value: '${item.socketCount} Open',
                            color: GameColors.cyanRune,
                          ),
                        ],
                      ),
                    ),

                    // Base Stats (STR, AGI, INT, VIT)
                    if (baseStats.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(title: 'BASE ATTRIBUTES', icon: Icons.insights),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: baseStats.entries.map((e) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: GameColors.bgSurface,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: GameColors.goldAccent.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '+${e.value} ',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: GameColors.goldAccent,
                                  ),
                                ),
                                Text(
                                  e.key,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    color: GameColors.textMain,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Buffs & Stat Rolls
                    if (buffs.isNotEmpty || statRolls.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(title: 'BUFFS & STAT ROLLS', icon: Icons.bolt),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GameColors.bgSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GameColors.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...buffs.map((b) => _AffixRow(text: b, color: GameColors.cyanRune)),
                            ...statRolls.map((s) => _AffixRow(text: s, color: GameColors.rarityMagic)),
                          ],
                        ),
                      ),
                    ],

                    // Unique Legendary Trait
                    if (uniqueTrait != null && uniqueTrait.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(title: 'UNIQUE TRAIT', icon: Icons.stars, color: GameColors.goldAccent),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GameColors.goldAccent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GameColors.goldAccent.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.auto_awesome, size: 16, color: GameColors.goldAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                uniqueTrait,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: GameColors.goldAccent,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Other Modifiers (Life-steal, elemental res, etc.)
                    if (otherModifiers.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(title: 'ADDITIONAL MODIFIERS', icon: Icons.auto_fix_high),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: GameColors.bgSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GameColors.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: otherModifiers.map((m) => _AffixRow(text: m, color: GameColors.voidPurple)).toList(),
                        ),
                      ),
                    ],

                    // Socketable Gem Effects
                    if (socketType != null || socketBonusWeapon != null || socketBonusArmor != null) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(title: 'SOCKET EMBEDDING BONUSES', icon: Icons.diamond, color: rc),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: rc.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: rc.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (socketType != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  'Gem Type: $socketType',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10,
                                    color: GameColors.textMuted,
                                  ),
                                ),
                              ),
                            if (socketBonusWeapon != null && socketBonusWeapon.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    const Icon(Icons.flash_on, size: 14, color: GameColors.crimsonBlood),
                                    const SizedBox(width: 6),
                                    Text(
                                      'When Socketed in Weapon: ',
                                      style: GoogleFonts.jetBrainsMono(fontSize: 10.5, color: GameColors.textDim),
                                    ),
                                    Expanded(
                                      child: Text(
                                        socketBonusWeapon,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: GameColors.crimsonBlood,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (socketBonusArmor != null && socketBonusArmor.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    const Icon(Icons.shield, size: 14, color: GameColors.terminalGreen),
                                    const SizedBox(width: 6),
                                    Text(
                                      'When Socketed in Armor: ',
                                      style: GoogleFonts.jetBrainsMono(fontSize: 10.5, color: GameColors.textDim),
                                    ),
                                    Expanded(
                                      child: Text(
                                        socketBonusArmor,
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: GameColors.terminalGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],

                    // Consumable Potency / Restoration Effect
                    if (healAmount != null && healAmount > 0) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(title: 'POTION RESTORATION EFFECT', icon: Icons.local_hospital, color: const Color(0xFF10B981)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite, size: 16, color: Color(0xFF10B981)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '+$healAmount Vitality Restored',
                                    style: GoogleFonts.cinzel(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                  Text(
                                    'Immediately soothes mortal wounds and stabilizes life force.',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: GameColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Set Modifiers
                    if (setInfo != null) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(
                        title: 'SET: ${(setInfo['name'] ?? 'ANCIENT SET').toString().toUpperCase()}',
                        icon: Icons.hub,
                        color: GameColors.raritySet,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GameColors.raritySet.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GameColors.raritySet.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (setInfo['pieces'] != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Pieces: ${(setInfo['pieces'] as List<dynamic>).join(', ')}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10,
                                    color: GameColors.textMuted,
                                  ),
                                ),
                              ),
                            if (setInfo['bonuses'] != null)
                              ...(setInfo['bonuses'] as List<dynamic>).map((b) {
                                final count = b['count'];
                                final desc = b['desc'];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '($count) Set: ',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: GameColors.raritySet,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '$desc',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: GameColors.textMain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ],

                    // Glitch Modifiers
                    if (glitchInfo != null) ...[
                      const SizedBox(height: 12),
                      _SectionHeader(
                        title: 'CORRUPTED / GLITCH MODIFIERS',
                        icon: Icons.warning_amber_rounded,
                        color: GameColors.rarityGlitched,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: GameColors.rarityGlitched.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GameColors.rarityGlitched.withValues(alpha: 0.8), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (glitchInfo['positive'] != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.add_circle, size: 15, color: GameColors.terminalGreen),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${glitchInfo['positive']}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: GameColors.terminalGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (glitchInfo['penalty'] != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.remove_circle, size: 15, color: GameColors.rarityGlitched),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${glitchInfo['penalty']}',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: GameColors.rarityGlitched,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Action Buttons Row
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: GameColors.borderSubtle),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'CLOSE',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: GameColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      if (onDrop != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: GameColors.crimsonBlood.withValues(alpha: 0.6)),
                              foregroundColor: GameColors.crimsonBlood,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.arrow_downward, size: 14, color: GameColors.crimsonBlood),
                            label: Text(
                              'DROP',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              onDrop!();
                            },
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEquipped
                                ? GameColors.crimsonBlood.withValues(alpha: 0.2)
                                : rc.withValues(alpha: 0.25),
                            foregroundColor: isEquipped ? GameColors.crimsonBlood : rc,
                            side: BorderSide(
                              color: isEquipped ? GameColors.crimsonBlood : rc,
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onAction();
                          },
                          child: Text(
                            isEquipped
                                ? 'UNEQUIP'
                                : (item.baseType == 'Potion' ||
                                        item.baseType == 'Consumable' ||
                                        item.baseType == 'Food' ||
                                        item.baseType == 'Scroll')
                                    ? 'USE NOW'
                                    : 'EQUIP NOW',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}

class _DetailCombatStat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;

  const _DetailCombatStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
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
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 8.5,
            color: GameColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.color = GameColors.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AffixRow extends StatelessWidget {
  final String text;
  final Color color;

  const _AffixRow({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5, right: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.5,
                color: GameColors.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
