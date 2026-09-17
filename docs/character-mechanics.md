# Vagabond Hero: Complete Character Progression, Classes, & Skills Codex

**File:** `character-mechanics.md`  
**System:** Character Lifecycles, 4-Tier Class Evolution, Dynamic Resources, Stat Allocations, & Skill Trees  

---

## 1. The Core Philosophy & 4-Tier Job Progression

In *Vagabond Hero*, **every single player starts their journey as a humble Vagabond**. The world is a harsh, fractured wasteland (The Shattered Expanse), and survival is earned. Through trials, boss conquests, and awakening milestones, characters evolve across **4 distinct Job Tiers**:

```
[ Tier 1: Level 1–20 ]
        VAGABOND (Survivor — Resource: Grit)
           │
           ├── [ Level 20 Job Choice ]
           │
┌──────────┴───────────┬──────────────────────┬──────────────────────┐
▼                      ▼                      ▼                      ▼
JUGGERNAUT             PHANTOM                WEAVER                 WARDEN
(Strength / Fury)      (Agility / Energy)     (Intelligence / Mana)  (Hybrid / Animus)
[ Tier 2: Level 21–50: First Job Awakening ]
│                      │                      │                      │
├── [ Lv 50 Awakening ]├── [ Lv 50 Awakening ]├── [ Lv 50 Awakening ]├── [ Lv 50 Awakening ]
▼                      ▼                      ▼                      ▼
• Berserker            • Assassin             • Elementalist         • Necromancer
• Void-Knight          • Rift-Sniper          • Blood Mage           • Druid
[ Tier 3: Level 51–70: Second Job Awakening ]
│                      │                      │                      │
└── [ Breaking the Core Quest @ Level 70 ]───────────────────────────┘
                       │
┌──────────────────────┴──────────────────────┬──────────────────────┐
▼                                             ▼                      ▼
• World-Breaker (from Berserker)              • Arch-Mage (from Elementalist)
• Aegis Lord (from Void-Knight)               • Crimson Sovereign (from Blood Mage)
• Shadow-Walker (from Assassin)               • Death-Caller (from Necromancer)
• Void-Stalker (from Rift-Sniper)             • Chimera-Lord (from Druid)
[ Tier 4: Level 70+ Pinnacle Third Job & Infinite Echo Levels ]
```

---

## 2. Core Attributes & Level-Up Stat Allocation Rules

Characters earn attribute points upon every level up to tailor their build towards survivability, devastating spell bursts, or untouchable speed.

### Primary Attributes

| Attribute | Primary Impact | Secondary Mechanics & Defensive Conversions | Preferred Archetypes |
| :--- | :--- | :--- | :--- |
| **Strength (STR)** | Increases **Physical Weapon Damage** (+1% per point). | Grants **+1 Total Armor** per 2 STR points. Increases Physical status resistance (Bleed/Stun). | Juggernaut, Berserker, Void-Knight |
| **Agility (AGI)** | Increases **Finesse/Ranged Weapon Damage** (+1% per point). | Grants **+0.1% Critical Strike Chance** and **+0.15% Evasion**. Increases Action Turn priority. | Phantom, Assassin, Rift-Sniper |
| **Intelligence (INT)** | Increases **Magic Spell Damage** (+1% per point) and **Elemental Resistances**. | Expands **Maximum Mana Pool** (+5 Max MP per INT for Weavers). Boosts status affliction chances. | Weaver, Elementalist, Blood Mage |
| **Stamina (STA)** | Universal Lifeline. Grants **+10 Maximum HP** per STA point. | Grants **+1 Total Armor** per 4 STA points. Enhances Potion healing recovery and HP Regeneration. | Warden, Tanks, Hybrid Survivors |

### Level-Up Stat Point System
* **Levels 1 – 20 (Vagabond Tier):** 
  * Gain **3 Free Attribute Points** per level.
  * Base Survivor Auto-Growth: +5 Max HP and +1 to All Stats automatically per level.
* **Levels 21 – 50 (First Job Tier):** 
  * Gain **5 Free Attribute Points** per level.
  * Class Innate Scaling: +10 Max HP per level, +1 to class core attribute (STR, AGI, INT, or STA).
* **Levels 51 – 70 (Second Job Tier):** 
  * Gain **6 Free Attribute Points** per level.
  * Specialized Subclass bonuses activate (+15 Max HP/level, high affix multipliers).
* **Level 70+ (The Infinite Echo System):**
  * Standard level progression caps at 70. Further EXP is converted into **Echo Levels**.
  * Each Echo Level awards **1 Echo Point** to invest in micro-perks:
    * *Offense:* +0.2% Crit Damage, +0.1% Attack/Cast Speed, +0.2% Elemental Damage.
    * *Defense:* +0.2% Total Armor, +0.1% Life Steal, +0.2% All-Resistances (75% hard cap).
    * *Utility:* +0.5% Gold Drop Rate, +0.5% Magic Find (Luck), +0.2% Resource Generation.

---

## 3. Dynamic Secondary Resources: Mechanics & Generation Loops

*Vagabond Hero* rejects the generic "one-size-fits-all Mana pool." Each class commands a dynamic secondary resource that dictates the flow of combat:

| Class Archetype | Resource Name | Range & HUD Theme | Generation & Combat Loop | Playstyle Dynamics |
| :--- | :--- | :--- | :--- | :--- |
| **Vagabond** | **`Grit`** | 0 – 100<br>🟤 Bronze (`#B45309`) | Starts at 50. Generates **+10/turn**, **+15 when struck**, and **+5 on basic attacks**. | Attrition survivor. Resource builds as danger rises, enabling emergency triage (*Patch Up*) and escape maneuvers. |
| **Juggernaut** | **`Fury`** | 0 – 100<br>🔴 Crimson (`#DC2626`) | Starts at 0. Generates **+10 on dealing melee hits**, **+15 when damaged**. Decays out of combat (-10/room). | Aggressive momentum. The player must maintain pressure to sustain devastating smashes and crowd control. |
| **Phantom** | **`Energy`** | 0 – 100<br>🟡 Amber (`#F59E0B`) | Starts at 100 (Full). Rapidly regenerates **+25 Energy every turn**. | High-tempo burst. Skills cost large chunks of Energy, demanding calculated multi-hit combo cycles. |
| **Weaver** | **`Mana`** | 0 – Max MP<br>🔵 Azure (`#38BDF8`) | Derived from INT: `Base 50 + (INT × 5)`. Regenerates via passive recovery (+5% Max MP/turn) and siphon spells. | Deep arcane reservoir. Huge spell expenditures offset by tactical mana siphons and barrier shielding. |
| **Warden** | **`Animus`** | 0 – 100<br>🟢 Emerald (`#10B981`) | Starts at 30. Generated when your **active summon strikes (+15)** or via **life-leeching skills (+10)**. | Symbiotic pack synergy. Your companion's actions feed your resource pool to reinforce barriers and cast curses. |

### Subclass Resource Specializations (2nd Job Awakening)
* **Berserker:** **`Bloodrage`** — Fury generation is doubled when current HP falls below 50%. Skills can sacrifice HP to guarantee critical hits.
* **Void-Knight:** **`Resolve`** — Converts 20% of all mitigated and reflected damage directly into Resolve for explosive counter-attacks.
* **Assassin:** **`Energy + Combo Points`** — Fast energy spenders build 1 to 5 Combo Points; finishing moves consume all points for multiplicative damage.
* **Rift-Sniper:** **`Focus`** — Remaining stationary grants +20 Focus per turn, consumed by long-range charged piercing shots.
* **Elementalist:** **`Tri-Flux`** — Cycling Fire, Ice, and Lightning spells builds elemental resonance, triggering free elemental explosions.
* **Blood Mage:** **`Blood Essence`** — Eliminates standard Mana. All spells consume current HP, balanced by enormous spell life-steal and blood shields.
* **Necromancer:** **`Corpses & Animus`** — Fallen enemies yield harvestable corpses on the battlefield to raise skeletal mages and detonate bone traps.
* **Druid:** **`Primal Surge`** — Shapeshifting into beast forms unlocks dual STR/INT scaling and generates Primal Surge with each claw strike.

---

## 4. Comprehensive Job Evolution Comparison Matrix

| Tier & Class | Level Bracket | Primary Stat | Secondary Resource | Signature Armor Profile | Defining Tactical Advantage |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Tier 1: Vagabond** | Lv 1 – 20 | All Balanced | `Grit` (0–100) | Scavenged Rags & Scrap | High baseline Luck/Gold find, emergency triage, terrain immunity. |
| **Tier 2: Juggernaut** | Lv 21 – 50 | STR (Priority) / STA | `Fury` (0–100) | Heavy Plate & Tower Shields | Unstoppable physical damage, threat control (Taunt), armor shredding. |
| **Tier 2: Phantom** | Lv 21 – 50 | AGI (Priority) / STA | `Energy` (0–100) | Finesse Leathers & Wraps | Extreme Evasion, multi-hit combos, stacking lethal poisons. |
| **Tier 2: Weaver** | Lv 21 – 50 | INT (Priority) / STA | `Mana` (Deep Pool) | Arcane Silk Robes | 100% accurate spells, mana shields, high AoE elemental devastation. |
| **Tier 2: Warden** | Lv 21 – 50 | STA / INT / STR | `Animus` (0–100) | Mail, Totems & Regalia | Autonomous pet combat, debuff transference, life-leeching vines. |
| **Tier 3: Berserker** | Lv 51 – 70 | STR | `Bloodrage` | Spiked Plates & 2H Axes | Low-HP damage scaling (Frenzy), massive life-steal, reckless swings. |
| **Tier 3: Void-Knight** | Lv 51 – 70 | STR / STA | `Resolve` | Bastion Plates & Heavy Shields | 100% Armor-to-Damage conversion, kinetic reflection, damage storage. |
| **Tier 3: Assassin** | Lv 51 – 70 | AGI | `Energy + Combo` | Shadow Cloaks & Kris | Guaranteed stealth crits, poison detonations, bypass target evasion. |
| **Tier 3: Rift-Sniper** | Lv 51 – 70 | AGI | `Focus / Energy` | Camouflage & Crossbows | 100% Armor penetration, charged 350% shots, caltrop room control. |
| **Tier 3: Elementalist** | Lv 51 – 70 | INT | `Mana & Tri-Flux` | Prismatic Elemental Robes | Multi-element cycle (Fire/Ice/Lightning), double actions, meteor strikes. |
| **Tier 3: Blood Mage** | Lv 51 – 70 | INT / STA | `Blood Essence / HP` | Sanguine Vestments | 2x Spell damage via HP sacrifice, pet sacrifice full recovery. |
| **Tier 3: Necromancer** | Lv 51 – 70 | INT | `Animus & Corpses` | Shrouds & Scythes | Up to 3 skeletal mages, corpse explosion AoE, minion resurrection. |
| **Tier 3: Druid** | Lv 51 – 70 | STR & INT Hybrid | `Animus & Primal` | Beast Carapaces & Antlers | Chimera shapeshifting, double hits, +100% Armor Barkskin. |
| **Tier 4: World-Breaker** | Lv 70+ Pinnacle | STR | `Pinnacle Fury` | Cataclysmic Plate | **Obliterate:** 500% execution strike that resets CD on kill. |
| **Tier 4: Aegis Lord** | Lv 70+ Pinnacle | STR / STA | `Pinnacle Resolve` | Bastion Aegis Plating | **Absolute Defense:** 2 turns complete invulnerability + 300% reflect. |
| **Tier 4: Shadow-Walker** | Lv 70+ Pinnacle | AGI | `Pinnacle Energy` | Eclipse Shroud | **Death Mark:** Detonates for 50% of all damage taken during countdown. |
| **Tier 4: Void-Stalker** | Lv 70+ Pinnacle | AGI | `Pinnacle Focus` | Horizon Calibrator | **Dimensional Piercer:** Permanently deletes 20% of enemy Max HP. |
| **Tier 4: Arch-Mage** | Lv 70+ Pinnacle | INT | `Pinnacle Mana` | Paradox Robes | **Time Stop:** Freezes world; player takes 3 consecutive free turns. |
| **Tier 4: Crimson Sovereign**| Lv 70+ Pinnacle | INT / STA | `Pinnacle Blood` | Sovereign's Regalia | **Blood Boil:** Sacrifices HP down to 1 for a 500% AoE nuclear blast. |
| **Tier 4: Death-Caller** | Lv 70+ Pinnacle | INT | `Pinnacle Animus` | Apocalypse Shroud | **Army of the Damned:** Summons 5 elite exploding skeletons instantly. |
| **Tier 4: Chimera-Lord** | Lv 70+ Pinnacle | STR & INT | `Pinnacle Primal` | Apex Tendons | **Apex Evolution:** Permanent Chimera Form + 10% team healing on all hits. |

---

## 5. Complete Skill Codices by Tier & Level

### Phase 1: The Vagabond Base Skills (Levels 1 – 20)
*All adventurers master these fundamentals before earning their first Job Change.*

* 🗡️ **[Lv 1] Scavenger's Strike:** A swift survival strike dealing 100% Weapon Damage. Has a 10% chance to dislodge 1–5 Silver Prisms from the enemy.  
  *(Cost: 0 Grit • Generates: +5 Grit • Cooldown: 0 Turns)*
* 🩹 **[Lv 5] Patch Up:** Emergency field triage that instantly restores 15% of Maximum HP. Inoperable while suffering from active Bleeding or Poison DoTs.  
  *(Cost: 30 Grit • Cooldown: 4 Turns)*
* 🏃 **[Lv 15] Desperate Flee:** Execute an evasion roll to disengage and escape from combat (50% base success rate). Automatically fails in Boss encounters.  
  *(Cost: 20 Grit • Cooldown: 1 Turn)*

---

### Phase 2: First Job Awakening Skills (Levels 21 – 50)

#### Juggernaut (Strength / Heavy Plate)
* 🔨 **[Lv 21] Heavy Smash:** Crushing overhead blow dealing 140% Physical Damage. Reduces target Evasion by 10% for 2 turns.  
  *(Cost: 20 Fury • Cooldown: 2 Turns)*
* 🛡️ **[Lv 30] Taunt:** Issues an enraged battle cry forcing enemies to target you instead of your Companion. Increases Total Armor by +25% for 3 turns.  
  *(Cost: 15 Fury • Generates +10 Fury when struck • Cooldown: 4 Turns)*
* 💥 **[Lv 45] Earthshatter:** Slams the ground to unleash an earthquake dealing 110% Physical Damage to all enemies in the room.  
  *(Cost: 40 Fury • Cooldown: 5 Turns)*

#### Phantom (Agility / Finesse Leathers)
* ⚡ **[Lv 21] Flurry:** High-tempo dual strike, each hit dealing 70% Finesse Damage with double the trigger chance for on-hit status affixes.  
  *(Cost: 25 Energy • Cooldown: 0 Turns)*
* 🧪 **[Lv 30] Venom-Laced Blade:** Coats weapons in neurotoxin. Next attack applies a Poison DoT dealing 20% AGI per turn for 4 turns.  
  *(Cost: 35 Energy • Cooldown: 3 Turns)*
* 💨 **[Lv 45] Smoke Bomb:** Detonates an obscurant pellet, instantly raising player Evasion to 80% for 1 turn.  
  *(Cost: 50 Energy • Cooldown: 6 Turns)*

#### Weaver (Intelligence / Arcane Robes)
* 🔮 **[Lv 21] Arcane Bolt:** Homing projectile of concentrated starlight dealing 130% Magic Damage. Automatically bypasses enemy Evasion (Never misses).  
  *(Cost: 10 Mana • Cooldown: 0 Turns)*
* 🌀 **[Lv 30] Siphon Energy:** Channels enemy aether, dealing 50% Magic Damage and restoring Mana equal to 100% of damage dealt.  
  *(Cost: 0 Mana • Generates: Mana • Cooldown: 3 Turns)*
* 🌐 **[Lv 45] Void Shield:** Projects an arcane barrier absorbing damage equal to 20% of player Maximum HP for 3 turns.  
  *(Cost: 30 Mana • Cooldown: 5 Turns)*

#### Warden (Animus / Pack Regalia)
* 🐺 **[Lv 21] Summon Void-Pup:** Conjures a loyal void beast possessing 30% of player Max HP. Automatically strikes each turn for 50% INT damage and generates +15 Animus.  
  *(Cost: 30 Animus • Cooldown: 8 Turns)*
* 🌿 **[Lv 30] Leeching Vines:** Thorny roots erupt from the floor, dealing 80% Magic Damage and healing the player for 50% of damage dealt.  
  *(Cost: 25 Animus • Cooldown: 3 Turns)*
* 🔗 **[Lv 45] Shared Burden:** Mystical tether that transfers all active debuffs (Poison, Chill, Weakness) from the player onto the active summon.  
  *(Cost: 20 Animus • Cooldown: 4 Turns)*

---

### Phase 3: Second Job Awakening Skills (Levels 51 – 70)

#### Berserker (from Juggernaut)
* 🪓 **[Lv 51] Reckless Swing:** Wild, cleaving blow dealing 200% Physical Damage. Player takes 10% of current HP in recoil damage.  
  *(Cost: 30 Fury + 10% Current HP • Cooldown: 2 Turns)*
* 🩸 **[Lv 60] Bloodlust:** Enters an ecstatic battle frenzy for 3 turns. Grants +20% Life Steal, but reduces Total Armor to 0.  
  *(Cost: 50 Fury • Cooldown: 5 Turns)*

#### Void-Knight (from Juggernaut)
* 🛡️ **[Lv 51] Shield Bash:** Slams the enemy with a towering shield, dealing Physical Damage equal to 100% of Total Armor. Stuns non-boss targets for 1 turn.  
  *(Cost: 25 Resolve • Cooldown: 3 Turns)*
* 🌌 **[Lv 60] Void Bulwark:** Complete kinetic absorption. Absorbs 100% of damage taken for 1 turn, releasing 50% as an explosive AoE blast next turn.  
  *(Cost: 40 Resolve • Cooldown: 6 Turns)*

#### Assassin (from Phantom)
* 🗡️ **[Lv 51] Eviscerate:** Consumes all Bleed and Poison stacks on the target to deal catastrophic burst damage (50% bonus damage per stack consumed).  
  *(Cost: 30 Energy • Cooldown: 2 Turns)*
* 👤 **[Lv 60] Shadow Cloak:** Dissolves into shadows for 2 turns. Enemies cannot target you. Your next attack from stealth is a guaranteed Critical Hit.  
  *(Cost: 40 Energy • Cooldown: 5 Turns)*

#### Rift-Sniper (from Phantom)
* 🎯 **[Lv 51] Aimed Shot:** Takes 1 turn to align the sights. On the 2nd turn, unleashes a 350% Finesse shot with 100% Armor Penetration.  
  *(Cost: 45 Focus • Cooldown: 4 Turns)*
* ⚙️ **[Lv 60] Caltrops:** Scatters barbed caltrops across the room. Any enemy making a melee attack suffers physical damage each attack for 3 turns.  
  *(Cost: 30 Focus • Cooldown: 4 Turns)*

#### Elementalist (from Weaver)
* 🔥 **[Lv 51] Elemental Cycle:** Cycles active stance (Fire -> Ice -> Lightning). Fire grants +25% Damage, Ice grants +30% Armor, Lightning grants 2 actions per turn.  
  *(Cost: 15 Mana • Cooldown: 1 Turn)*
* ☄️ **[Lv 60] Cataclysm:** Calls down a cataclysmic elemental meteor, dealing 250% AoE Magic Damage matching your active stance.  
  *(Cost: 40 Mana • Cooldown: 5 Turns)*

#### Blood Mage (from Weaver)
* 🩸 **[Lv 51] Hemorrhage:** Siphons player vitality into dark sorcery. Deals 150% Magic Damage costing 10% Max HP instead of Mana.  
  *(Cost: 10% Max HP • Cooldown: 1 Turn)*
* 💀 **[Lv 60] Crimson Pact:** Sacrifices your active Companion instantly to fully restore 100% of player HP and Mana. (Once per node).  
  *(Cost: Companion Life • Cooldown: 99 Turns)*

#### Necromancer (from Warden)
* 💀 **[Lv 51] Raise Skeletal Mage:** Raises a skeletal frost mage from fallen essence that casts ranged ice lances. Can control up to 3 active skeletons.  
  *(Cost: 25 Animus • Cooldown: 3 Turns)*
* 💣 **[Lv 60] Corpse Explosion:** Detonates a fallen enemy corpse, dealing damage equal to 100% of its Max HP as AoE damage to all remaining foes.  
  *(Cost: 35 Animus • Cooldown: 2 Turns)*

#### Druid (from Warden)
* 🐺 **[Lv 51] Chimera Shift:** Metamorphose into a terrifying Void Chimera for 4 turns. Replaces spells with primal claws scaling off both STR and INT.  
  *(Cost: 40 Animus • Cooldown: 6 Turns)*
* 🌲 **[Lv 60] Barkskin:** Hardens flesh into petrified ironwood. Increases Total Armor by +100% and grants complete immunity to Critical Hits for 3 turns.  
  *(Cost: 30 Animus • Cooldown: 5 Turns)*

---

### Phase 4: Third Job Pinnacle Classes (Level 70+ Post-"Breaking the Core")

*Pinnacle abilities transcend standard game boundaries to conquer New Game+ and deep Echo dungeons.*

* 💥 **[Lv 70 World-Breaker] Obliterate:** A reality-rending execution strike dealing 500% Physical Damage. If this strike slays the target, its cooldown instantly resets to 0.  
  *(Cost: 60 Fury + 20% Current HP • Cooldown: 4 Turns)*
* 🛡️ **[Lv 70 Aegis Lord] Absolute Defense:** For 2 turns, you are completely impervious to all damage and automatically reflect all incoming attacks at 300% strength.  
  *(Cost: 50 Resolve • Cooldown: 7 Turns)*
* ⏳ **[Lv 70 Shadow-Walker] Death Mark:** Brands an enemy with a death mark. After 3 turns, the mark detonates, dealing True Damage equal to 50% of all damage the target took during the countdown.  
  *(Cost: 50 Energy • Cooldown: 5 Turns)*
* 🏹 **[Lv 70 Void-Stalker] Dimensional Piercer:** Fires a quantum arrow that bypasses the enemy's current HP bar entirely, permanently reducing the target's Max HP by 20%.  
  *(Cost: 60 Focus • Cooldown: 4 Turns)*
* ⌛ **[Lv 70 Arch-Mage] Time Stop:** Completely freezes global combat ticks. The player takes 3 consecutive turns back-to-back while all enemies remain frozen.  
  *(Cost: 60 Mana • Cooldown: 8 Turns)*
* 🩸 **[Lv 70 Crimson Sovereign] Blood Boil:** Drains player health down to exactly 1 HP, unleashing an apocalyptic shockwave dealing 5× the total HP sacrificed as raw Magic Damage.  
  *(Cost: All HP down to 1 • Cooldown: 8 Turns)*
* 👑 **[Lv 70 Death-Caller] Army of the Damned:** Summons 5 elite maximum-level skeleton champions simultaneously, ignoring standard summon limits. Skeletons explode on death.  
  *(Cost: 70 Animus • Cooldown: 8 Turns)*
* 🐾 **[Lv 70 Chimera-Lord] Apex Evolution:** Permanently merges beast forms into human form. Grants permanent Chimera form buffs without transforming, and heals all allies for 10% of all damage dealt.  
  *(Passive: Always Active • Cooldown: 0 Turns)*
