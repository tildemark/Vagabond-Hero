import glob
import re
import json

DOCS_DIR = r'c:\code\Vagabond-Hero\docs\items'
JSON_PATH = r'c:\code\Vagabond-Hero\landing\guide\items_database.json'
DART_PATH = r'c:\code\Vagabond-Hero\mobile\lib\core\database\item_templates.dart'

with open(JSON_PATH, 'r', encoding='utf-8') as f:
    db_items = json.load(f)
db_map = {it['id']: it for it in db_items}

all_extracted = {}
for fpath in sorted(glob.glob(f'{DOCS_DIR}/*.md')):
    with open(fpath, 'r', encoding='utf-8') as f:
        text = f.read()
    chunks = re.split(r'(?m)^(?=\|\s*[A-Z0-9\-]{2,10}\s*\|)', text)
    for chunk in chunks:
        chunk = chunk.strip()
        if not chunk.startswith('|'):
            continue
        flat = ' '.join(line.strip() for line in chunk.split('\n') if line.strip())
        cols = [c.strip() for c in flat.split('|')]
        if cols and cols[0] == '':
            cols.pop(0)
        if cols and cols[-1] == '':
            cols.pop()
        if cols and cols[0] in db_map:
            all_extracted[cols[0]] = cols

def extract_modifiers(raw_text):
    text = re.sub(r'<br\s*/?>', '\n', raw_text)
    text = re.sub(r'\s{3,}', '\n', text)
    lines = [l.strip() for l in text.split('\n') if l.strip()]
    mods = []
    for l in lines:
        l = re.sub(r'\+[\d\sto]+Sockets?', '', l, flags=re.IGNORECASE).strip()
        if l and not l.startswith('---'):
            mods.append(l)
    return mods

set_bonuses = {}
current_set_name = None
current_set_bonus = None
for fpath in sorted(glob.glob(f'{DOCS_DIR}/set-*.md')):
    with open(fpath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    for l in lines:
        l_str = l.strip()
        m_set = re.search(r'### Set \d+:\s*(.+)', l_str)
        if m_set:
            current_set_name = m_set.group(1).strip()
        m_bonus = re.search(r'\*\s*(\[\d+-Piece[^\]]*\]:.+)', l_str)
        if m_bonus:
            current_set_bonus = m_bonus.group(1).strip()
        m_id = re.search(r'\|\s*(S[A-Z0-9\-]+)\s*\|', l_str)
        if m_id:
            s_id = m_id.group(1).strip()
            set_bonuses[s_id] = (current_set_name, current_set_bonus)

updated_items = []
for it in db_items:
    it_copy = dict(it)
    it_id = it['id']
    rarity = it['rarity']
    cols = all_extracted.get(it_id, [])
    
    raw_mod_col = ''
    if rarity in ['Magic', 'Rare', 'Relic', 'Set']:
        raw_mod_col = cols[5] if len(cols) > 5 else ''
    elif rarity == 'Mythic':
        raw_mod_col = cols[6] if len(cols) > 7 else (cols[5] if len(cols) > 5 else '')
    extracted_mods = extract_modifiers(raw_mod_col)
    
    final_mods = []
    if rarity == 'Common':
        # base stat + 1 optional modifier
        final_mods = ['+1 Optional Modifier (Class-Weighted Roll)']
    elif rarity == 'Magic':
        # base stat + 1 random modifier + 1 optional modifier
        if len(extracted_mods) >= 2:
            final_mods = [extracted_mods[0], extracted_mods[1] + ' (Optional)']
        elif len(extracted_mods) == 1:
            final_mods = [extracted_mods[0], '+1 Optional Modifier (Class-Weighted Roll)']
        else:
            final_mods = ['+1 Random Modifier (Class Pool)', '+1 Optional Modifier (Class-Weighted Roll)']
    elif rarity == 'Rare':
        # base stat + 2 random modifier + 1 optional modifier
        if len(extracted_mods) >= 3:
            final_mods = [extracted_mods[0], extracted_mods[1], extracted_mods[2] + ' (Optional)']
        elif len(extracted_mods) == 2:
            final_mods = [extracted_mods[0], extracted_mods[1], '+1 Optional Modifier (Class-Weighted Roll)']
        elif len(extracted_mods) == 1:
            final_mods = [extracted_mods[0], '+1 Random Modifier (Class Pool)', '+1 Optional Modifier (Class-Weighted Roll)']
        else:
            final_mods = ['+1 Random Modifier (Class Pool)', '+1 Random Modifier (Class Pool)', '+1 Optional Modifier (Class-Weighted Roll)']
    elif rarity == 'Relic':
        # base stat + 1 unique modifier (unique to item) + 2 random modifier
        final_mods = extracted_mods if extracted_mods else ['+1 Unique Affix (Signature)', '+1 Random Modifier (Class Pool)', '+1 Random Modifier (Class Pool)']
    elif rarity == 'Mythic':
        # high base stat + 1 unique modifier (unique to item) + 1 high stat modifier + 1 random modifier
        final_mods = extracted_mods
    elif rarity == 'Set':
        # high base stat + 1 high stat modifier + 2 random modifier + set attribute
        set_info = set_bonuses.get(it_id)
        final_mods = list(extracted_mods)
        if set_info and set_info[1]:
            clean_bonus = re.sub(r'\*\*', '', set_info[1])
            final_mods.append(f'Set Bonus ({set_info[0]}): {clean_bonus}')
    
    it_copy['modifiers'] = final_mods
    updated_items.append(it_copy)

# Save to JSON
with open(JSON_PATH, 'w', encoding='utf-8') as f:
    json.dump(updated_items, f, indent=2)

print(f'Successfully updated {JSON_PATH} ({len(updated_items)} items)')

# Generate Dart templates
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

for it in updated_items:
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

print(f'Successfully updated {DART_PATH} ({len(updated_items)} items)')
