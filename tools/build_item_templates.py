import json

with open(r'c:\code\Vagabond-Hero\landing\guide\items_database.json', 'r', encoding='utf-8') as f:
    items = json.load(f)

def esc(s):
    return s.replace('\\', '\\\\').replace("'", "\\'").replace('\n', ' ').replace('\r', '')

lines = []
lines.append('// GENERATED ITEM TEMPLATES FROM /docs/items')
lines.append('// Comprehensive database of 425 canonical equipment items')
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

for it in items:
    mods_entries = ["'" + esc(m) + "'" for m in it['modifiers']]
    mods_joined = ', '.join(mods_entries)
    lines.append('  ItemTemplate(')
    lines.append("    id: '" + esc(it['id']) + "',")
    lines.append("    name: '" + esc(it['name']) + "',")
    lines.append("    baseType: '" + esc(it['baseType']) + "',")
    lines.append("    rarity: '" + esc(it['rarity']) + "',")
    lines.append("    equipSlot: '" + esc(it['equipSlot']) + "',")
    lines.append(f"    reqLvl: {it['reqLvl']},")
    lines.append(f"    minDamage: {it['minDamage']},")
    lines.append(f"    maxDamage: {it['maxDamage']},")
    lines.append(f"    armorValue: {it['armorValue']},")
    lines.append(f"    socketCount: {it['socketCount']},")
    lines.append("    description: '" + esc(it['description']) + "',")
    lines.append(f"    modifiers: [{mods_joined}],")
    lines.append("    uniqueTrait: '" + esc(it['uniqueTrait']) + "',")
    lines.append('  ),')

lines.append('];')
lines.append('')

out_path = r'c:\code\Vagabond-Hero\mobile\lib\core\database\item_templates.dart'
with open(out_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print(f'Successfully generated {out_path} ({len(items)} items)')
