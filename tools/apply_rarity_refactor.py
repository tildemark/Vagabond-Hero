import glob
import re
import json

DOCS_DIR = r'c:\code\Vagabond-Hero\docs\items'
JSON_PATH = r'c:\code\Vagabond-Hero\landing\guide\items_database.json'
DART_PATH = r'c:\code\Vagabond-Hero\mobile\lib\core\database\item_templates.dart'

with open(JSON_PATH, 'r', encoding='utf-8') as f:
    db_items = json.load(f)
db_map = {it['id']: it for it in db_items}

# Regex to extract items from markdown tables
items_data = {}
for fpath in sorted(glob.glob(f'{DOCS_DIR}/*.md')):
    with open(fpath, 'r', encoding='utf-8') as f:
        text = f.read()
    
    matches = re.finditer(r'\|\s*([A-Z0-9\-]{2,10})\s*\|\s*\*\*([^*]+)\*\*\s*\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|?(.*?)(?=\n\||\Z)', text, re.DOTALL)
    for m in matches:
        item_id = m.group(1).strip()
        items_data[item_id] = (fpath, m.groups())

def extract_modifiers_from_text(raw_text):
    text = re.sub(r'<br\s*/?>', '\n', raw_text)
    text = re.sub(r'\s{3,}', '\n', text)
    lines = [l.strip() for l in text.split('\n') if l.strip()]
    mods = []
    for l in lines:
        l = re.sub(r'\+[\d\sto]+Sockets?', '', l, flags=re.IGNORECASE).strip()
        l = l.strip('|').strip()
        if l and not l.startswith('---'):
            mods.append(l)
    return mods

parsed_raw_mods = {}
for it in db_items:
    sid = it['id']
    if sid not in items_data:
        parsed_raw_mods[sid] = []
        continue
    fpath, groups = items_data[sid]
    candidate_cols = []
    for g in groups[3:]:
        g_clean = g.strip()
        if '+' in g_clean or '%' in g_clean:
            candidate_cols.append(g_clean)
    if candidate_cols:
        parsed_raw_mods[sid] = extract_modifiers_from_text(candidate_cols[0])
    else:
        parsed_raw_mods[sid] = []

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

# Thematic Permanent Stats for Mythic Weapons
MYTHIC_PERM_AFFIXES = {
    'W2-J04': '+15% to 25% Total Armor (Permanent)',
    'W2-J05': '+20% to 40% Crit Damage (Permanent)',
    'W2-P04': '+15% to 25% Life Steal (Permanent)',
    'W2-P05': '+50% to 100% Crit Damage (Permanent)',
    'W2-W04': '+15% to 25% All Resist (Permanent)',
    'W2-W05': '+100 to 200 Max Mana (Permanent)',
    'W2-D04': '+10% to 20% Boss Damage (Permanent)',
    'W2-D05': '+15% to 25% All Resist (Permanent)',
    'W3-J03': '+20% to 35% Attack Speed (Permanent)',
    'W3-J04': '+20% to 40% Total Armor (Permanent)',
    'W3-J05': '+30% to 50% Boss Damage (Permanent)',
    'W3-P03': '+20% to 30% Attack Speed (Permanent)',
    'W3-P04': '+100% to 150% Crit Damage (Permanent)',
    'W3-P05': '+20% to 30% Evasion (Permanent)',
    'W3-W03': '+20% to 30% Cast Speed (Permanent)',
    'W3-W04': '+15% to 25% Life Steal (Permanent)',
    'W3-W05': '+300 to 500 Max Mana (Permanent)',
    'W3-D03': '+25% to 40% Magic Find (Permanent)',
    'W3-D04': '+20% to 30% Crit Chance (Permanent)',
    'W3-D05': '+500 to 800 Max HP (Permanent)',
}

updated_items = []
for it in db_items:
    it_copy = dict(it)
    it_id = it['id']
    rarity = it['rarity']
    extracted_mods = parsed_raw_mods.get(it_id, [])
    
    final_mods = []
    
    if rarity == 'Common':
        # base stat + 1 optional core/modifier stat
        final_mods = ['+1 Optional Core/Modifier Stat (Class Roll)']
        
    elif rarity == 'Magic':
        # base stat + 1 core stat + 1 optional modifier
        core_stat = extracted_mods[0] if len(extracted_mods) >= 1 else '+Core Stat'
        optional_mod = (extracted_mods[1] + ' (Optional)') if len(extracted_mods) >= 2 else '+1 Optional Modifier (Combat/Utility Roll)'
        final_mods = [core_stat, optional_mod]
        
    elif rarity == 'Rare':
        # base stat + 1 core stat + 1 random modifier + 1 optional modifier
        core_stat = extracted_mods[0] if len(extracted_mods) >= 1 else '+Core Stat'
        random_mod = extracted_mods[1] if len(extracted_mods) >= 2 else '+1 Random Modifier (Combat/Elemental)'
        optional_mod = (extracted_mods[2] + ' (Optional)') if len(extracted_mods) >= 3 else '+1 Optional Modifier (Class/Utility Roll)'
        final_mods = [core_stat, random_mod, optional_mod]
        
    elif rarity == 'Relic':
        # base stat + 1 core stat + 1 permanent modifier (does not change) + 2 random modifier
        if len(extracted_mods) >= 4:
            core_stat = extracted_mods[0]
            perm_mod = extracted_mods[1] + ' (Permanent)'
            rand_mod1 = extracted_mods[2]
            rand_mod2 = extracted_mods[3]
            final_mods = [core_stat, perm_mod, rand_mod1, rand_mod2]
        elif len(extracted_mods) == 3:
            core_stat = extracted_mods[0]
            perm_mod = extracted_mods[1] + ' (Permanent)'
            rand_mod1 = extracted_mods[2]
            rand_mod2 = '+1 Random Class Modifier'
            final_mods = [core_stat, perm_mod, rand_mod1, rand_mod2]
        elif len(extracted_mods) == 2:
            core_stat = extracted_mods[0]
            perm_mod = extracted_mods[1] + ' (Permanent)'
            final_mods = [core_stat, perm_mod, '+1 Random Class Modifier', '+1 Random Class Modifier']
        else:
            final_mods = [
                '+Core Stat (Fixed)',
                '+1 Permanent Signature Modifier (Does Not Change)',
                '+1 Random Class Modifier',
                '+1 Random Class Modifier'
            ]
            
    elif rarity == 'Mythic':
        # +1 high base stat + 1 high permanent modifier (does not change) + 2 random modifier
        perm_affix = MYTHIC_PERM_AFFIXES.get(it_id)
        if not perm_affix:
            perm_affix = (extracted_mods[1] + ' (Permanent)') if len(extracted_mods) >= 2 else '+1 High Permanent Thematic Trait (Does Not Change)'
        
        stat_affix1 = extracted_mods[0] if len(extracted_mods) >= 1 else '+High Core Attribute'
        stat_affix2 = extracted_mods[2] if len(extracted_mods) >= 3 else '+1 High Random Class Affix'
        
        final_mods = [perm_affix, stat_affix1, stat_affix2]
        # Ensure uniqueTrait is set for the mythic signature
        if not it_copy.get('uniqueTrait') and it_copy.get('description'):
            it_copy['uniqueTrait'] = it_copy['description']
            
    elif rarity == 'Set':
        # +1 high base stat + 1 high stat modifier + 2 random modifier + set attribute
        set_info = set_bonuses.get(it_id)
        final_mods = list(extracted_mods)
        if len(final_mods) == 2:
            final_mods.append('+1 Random Class Modifier')
        if set_info and set_info[1]:
            clean_bonus = re.sub(r'\*\*', '', set_info[1])
            final_mods.append(f'Set Attribute ({set_info[0]}): {clean_bonus}')
            
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
