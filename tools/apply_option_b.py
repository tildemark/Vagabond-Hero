import os
import glob
import re
import json

DOCS_DIR = r'c:\code\Vagabond-Hero\docs\items'
JSON_OUT = r'c:\code\Vagabond-Hero\landing\guide\items_database.json'
DART_OUT = r'c:\code\Vagabond-Hero\mobile\lib\core\database\item_templates.dart'

def clean_doc_markdowns():
    """Clean +Socket lines from the markdown docs."""
    files = sorted(glob.glob(os.path.join(DOCS_DIR, '*.md')))
    cleaned_count = 0
    for fpath in files:
        with open(fpath, 'r', encoding='utf-8') as f:
            content = f.read()

        orig = content
        # Remove <br>+1 Socket or <br>+1 to 2 Sockets or +2 Sockets<br>
        content = re.sub(r'<br\s*/?>\s*(\+[\d\sto]+Sockets?)\s*', '', content, flags=re.IGNORECASE)
        content = re.sub(r'(\+[\d\sto]+Sockets?)\s*<br\s*/?>', '', content, flags=re.IGNORECASE)
        content = re.sub(r', Sockets\)', ')', content)
        content = re.sub(r', Sockets', '', content)

        if content != orig:
            with open(fpath, 'w', encoding='utf-8') as f:
                f.write(content)
            cleaned_count += 1
            print(f'Cleaned sockets in {os.path.basename(fpath)}')

    print(f'Markdown docs cleaned: {cleaned_count}/{len(files)}')

def update_database_json_and_dart():
    with open(JSON_OUT, 'r', encoding='utf-8') as f:
        items = json.load(f)

    print(f'Loaded {len(items)} items from {JSON_OUT}')

    for it in items:
        # 1. Clean modifiers
        new_mods = []
        for m in it.get('modifiers', []):
            cleaned_m = re.sub(r'\+[\d\sto]+Sockets?', '', m, flags=re.IGNORECASE).strip()
            if cleaned_m:
                new_mods.append(cleaned_m)
        it['modifiers'] = new_mods

        # 2. In Option B: Natural item drop socketCount is 0
        it['socketCount'] = 0

    # Write updated JSON
    with open(JSON_OUT, 'w', encoding='utf-8') as f:
        json.dump(items, f, indent=2)
    print(f'Updated {JSON_OUT} with pure modifiers and 0 intrinsic sockets.')

    # Write updated Dart templates
    def esc(s):
        return s.replace('\\', '\\\\').replace("'", "\\'").replace('\n', ' ').replace('\r', '')

    lines = []
    lines.append('// GENERATED ITEM TEMPLATES FROM /docs/items (OPTION B: PURE MODIFIERS & ARTISAN SOCKETING)')
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

    with open(DART_OUT, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print(f'Successfully generated {DART_OUT} ({len(items)} items)')

if __name__ == '__main__':
    clean_doc_markdowns()
    update_database_json_and_dart()
