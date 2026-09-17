import json
import re

DATABASE_PATH = r'landing/guide/items_database.json'
DART_PATH = r'mobile/lib/core/database/item_templates.dart'
DOC_PATH = r'docs/items/armor-mythic.md'

def main():
    # 1. Load current items_database.json
    with open(DATABASE_PATH, 'r', encoding='utf-8') as f:
        items = json.load(f)

    existing_ids = {it['id'] for it in items}

    # 2. Parse docs/items/armor-mythic.md
    with open(DOC_PATH, 'r', encoding='utf-8') as f:
        text = f.read()

    matches = list(re.finditer(r'\|\s*(M-[A-Z0-9]+)\s*\|\s*\*\*([^*]+)\*\*\s*\|\s*([^|]+)\|\s*([^|]+)\|\s*(\d+)\s*\|\s*([^|]+)\|\s*([^|]+)\|\s*([^|\n]+)', text))

    new_items = []
    for m in matches:
        mid, name, slot, cls, lvl, base_stat, raw_mods, desc = [x.strip() for x in m.groups()]
        if mid in existing_ids:
            continue
        
        m_armor = re.search(r'(\d+)\s*Armor', base_stat)
        armor_val = int(m_armor.group(1)) if m_armor else 0
        
        mod_lines = [l.strip() for l in re.sub(r'<br\s*/?>', '\n', raw_mods).split('\n') if l.strip()]
        
        m_trait = re.search(r'\*\*([^*]+):\*\*\s*(.+)', desc)
        if m_trait:
            trait_name = m_trait.group(1).strip()
            trait_text = m_trait.group(2).strip()
            trait_full = f'{trait_name}: {trait_text}'
            clean_desc = trait_text
        else:
            trait_full = desc
            clean_desc = desc

        equip_slot = slot
        base_type = slot if slot != 'Torso' else 'Chest'
        if slot == 'Torso':
            equip_slot = 'Chest'

        new_items.append({
            'id': mid,
            'name': name,
            'baseType': base_type,
            'rarity': 'Mythic',
            'equipSlot': equip_slot,
            'reqLvl': int(lvl),
            'minDamage': 0,
            'maxDamage': 0,
            'armorValue': armor_val,
            'socketCount': 0,
            'description': clean_desc,
            'modifiers': mod_lines,
            'uniqueTrait': trait_full,
            'rawType': slot,
            'classTag': cls
        })

    print(f'Adding {len(new_items)} new Mythic armor items to {DATABASE_PATH}')
    all_items = items + new_items

    with open(DATABASE_PATH, 'w', encoding='utf-8') as f:
        json.dump(all_items, f, indent=2)

    # 3. Regenerate mobile/lib/core/database/item_templates.dart
    def esc(s):
        return str(s).replace('\\', '\\\\').replace("'", "\\'").replace('\n', ' ').replace('\r', '')

    lines = []
    lines.append('// GENERATED ITEM TEMPLATES FROM /docs/items (NEW RARITIES: Common, Magic, Rare, Relic, Mythic, Set, Corrupted)')
    lines.append(f'// Comprehensive database of {len(all_items)} canonical equipment items')
    lines.append('')
    lines.append('class ItemTemplate {')
    lines.append('  final String id;')
    lines.append('  final String name;')
    lines.append('  final String baseType;')
    lines.append('  final String rarity;')
    lines.append('  final String equipSlot;')
    lines.append('  final int reqLvl;')
    lines.append('  final int minDamage;')
    lines.append('  final int maxDamage;')
    lines.append('  final int armorValue;')
    lines.append('  final int socketCount;')
    lines.append('  final String description;')
    lines.append('  final List<String> modifiers;')
    lines.append('  final String uniqueTrait;')
    lines.append('')
    lines.append('  const ItemTemplate({')
    lines.append('    required this.id,')
    lines.append('    required this.name,')
    lines.append('    required this.baseType,')
    lines.append('    required this.rarity,')
    lines.append('    required this.equipSlot,')
    lines.append('    required this.reqLvl,')
    lines.append('    required this.minDamage,')
    lines.append('    required this.maxDamage,')
    lines.append('    required this.armorValue,')
    lines.append('    required this.socketCount,')
    lines.append('    required this.description,')
    lines.append('    required this.modifiers,')
    lines.append('    required this.uniqueTrait,')
    lines.append('  });')
    lines.append('}')
    lines.append('')
    lines.append('const List<ItemTemplate> kItemTemplates = [')

    for it in all_items:
        mods_entries = ["'" + esc(m) + "'" for m in it['modifiers']]
        mods_joined = ', '.join(mods_entries)
        lines.append('  ItemTemplate(')
        lines.append(f"    id: '{esc(it['id'])}',")
        lines.append(f"    name: '{esc(it['name'])}',")
        lines.append(f"    baseType: '{esc(it['baseType'])}',")
        lines.append(f"    rarity: '{esc(it['rarity'])}',")
        lines.append(f"    equipSlot: '{esc(it['equipSlot'])}',")
        lines.append(f"    reqLvl: {it['reqLvl']},")
        lines.append(f"    minDamage: {it['minDamage']},")
        lines.append(f"    maxDamage: {it['maxDamage']},")
        lines.append(f"    armorValue: {it['armorValue']},")
        lines.append(f"    socketCount: {it['socketCount']},")
        lines.append(f"    description: '{esc(it['description'])}',")
        lines.append(f"    modifiers: [{mods_joined}],")
        lines.append(f"    uniqueTrait: '{esc(it['uniqueTrait'])}',")
        lines.append('  ),')

    lines.append('];')
    lines.append('')

    with open(DART_PATH, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print(f'Successfully updated {DART_PATH} ({len(all_items)} items)')

if __name__ == '__main__':
    main()
