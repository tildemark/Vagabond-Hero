# Vagabond Hero: Comprehensive Item & Loot Mechanics Design Document

## 1. Equippable Body Parts (Slots)

The player and their primary Companion can equip items in the following distinct slots. Two-handed weapons will automatically lock the Off-Hand slot.

* **Head:** Hats, Caps, Helmets, Masks, Hoods.
* **Neck:** Necklaces, Amulets, Chokers.
* **Torso:** Chest Plates, Shirts, Robes, Harnesses.
* **Waist:** Belts, Sashes, Girdles.
* **Arms:** Bracers, Gauntlets, Gloves, Armbands.
* **Legs:** Pants, Greaves, Legguards, Skirts.
* **Feet:** Shoes, Sandals, Boots, Sabatons.
* **L-Finger:** Rings, Bands.
* **R-Finger:** Rings, Bands.
* **L-Hand (Main Hand):** 1H Weapons, 2H Weapons.
* **R-Hand (Off-Hand):** Shields, Magic Focuses, Quivers, Dual-Wield 1H Weapons.

---

## 2. The "Smart Loot" & Affix Pool System

To prevent the frustration of a Strength-based melee character receiving useless +Mana modifiers, the game utilizes a **Smart Loot System** with weighted Affix Pools.

1. **Class-Weighted Drops (80/20 Rule):** When an item drops, there is an 80% chance it rolls an Item Base suitable for the player's current Job. The remaining 20% drops random loot (useful for equipping Companions or selling for gold).
2. **Affix Pools by Item Base:** Modifiers are restricted by the weapon/armor type.

* *Physical Weapons (Swords, Axes):* Can only roll from the Melee Affix Pool (+Strength, +Bleed, +Attack Speed).
* *Magical Weapons (Staffs, Wands):* Can only roll from the Magic Affix Pool (+Intelligence, +Mana, +Cast Speed).
* *Armor/Jewelry:* Rolls from a Universal Defense Pool (+Max HP, +Resistances, +Agility/Armor), but heavily weights the core stat of the player's current class (e.g., Juggernauts will see +Strength on their armor far more often than +Intelligence).

---

## 3. Rarity Tiers & Modifier Budgets (Class-Related Drops)

Drops are strictly related to the player's current character class. An item's Rarity dictates its base stats, signature traits, class affixes, and optional modifier rolls.

| Rarity | UI Color | Modifier Composition | Item Behavior & Budget Rule |
| --- | --- | --- | --- |
| **Common** | White | Base Stat + 1 Optional Modifier | Baseline equipment with authentic base stats (Damage or Armor) plus **1 Optional Modifier** rolled from the player's class pool. |
| **Magic** | Blue | Base Stat + 1 Random Modifier + 1 Optional Modifier | Standard enchanted gear. Always rolls **1 guaranteed random class modifier** and **1 optional modifier** for early build customization. |
| **Rare** | Yellow | Base Stat + 2 Random Modifiers + 1 Optional Modifier | The leveling and mid-game backbone. Guarantees **2 random class modifiers** plus **1 optional modifier** with elevated stat ranges. |
| **Relic** | Purple | Base Stat + 1 Unique Modifier + 2 Random Modifiers | Fixed identity equipment drops. Possesses **1 signature Unique Modifier** (unique to the specific item identity) plus **2 random class-weighted modifiers**. |
| **Mythic** | Orange | High Base Stat + 1 Unique Modifier + 1 High Stat Modifier + 1 Random Modifier | Pinnacle class weapons and armor. Rolls **amplified High Base Stats**, **1 signature Unique Trait** (gameplay-altering rule), **1 High Stat Modifier**, and **1 random class modifier**. |
| **Set** | Green | High Base Stat + 1 High Stat Modifier + 2 Random Modifiers + Set Attribute | Synergy armor and armaments. Features **High Base Stats**, **1 High Stat Modifier**, **2 random class modifiers**, and the distinctive **Set Attribute bonus** active at 2, 3, or 4 pieces. |
| **Corrupted** | Red/Glitch | As Is + Corrupted Modifier Infusion | *Post-Echo Pinnacle Drops.* Injects a game-breaking **Corrupted Modifier** (immense buff paired with a severe, build-testing drawback) on top of the item's existing budget. |

---

## 4. Stat Allocation & Item Level Scaling

The power of an item's Base Stats (raw Damage/Armor) and its Modifiers (+Strength, +Fire Damage) is determined by the **Item Level (iLvl)**, which matches the level of the monster that dropped it.

Here is the scaling structure across the game's progression phases:

### Phase 1: The Survivor (Levels 1 - 20)

* **Focus:** Learning mechanics, simple survival, generic gear.
* **Base Weapon Damage:** 2 – 25
* **Base Armor (Per Piece):** 1 – 15
* **Modifier Values:** Core Stats (+1 to +10), Health (+5 to +30), Resistances (+2% to +5%).
* **Equip Rules:** Usable by any "Vagabond" base class.

### Phase 2: The First Awakening (Levels 21 - 50)

* **Focus:** Elemental damage, critical hits, establishing a build identity.
* **Base Weapon Damage:** 30 – 120
* **Base Armor (Per Piece):** 20 – 80
* **Modifier Values:** Core Stats (+15 to +45), Health (+50 to +200), Resistances (+10% to +20%).
* **Equip Rules:** Many items now require the player to have completed their 1st Job Change (e.g., "Requires: Juggernaut, Phantom, Weaver, or Warden").

### Phase 3: The Ascendant (Levels 51 - 70)

* **Focus:** Massive synergistic Set items, optimizing sockets, preparing for endgame.
* **Base Weapon Damage:** 150 – 400
* **Base Armor (Per Piece):** 100 – 250
* **Modifier Values:** Core Stats (+50 to +120), Health (+300 to +800), Resistances (+25% to +40%).
* **Equip Rules:** High-tier Legendaries require the 2nd Job Change (e.g., "Requires: Void-Knight or Blood Mage").

### Phase 4: Pinnacle Mastery (Level 70 / 3rd Job Change)

* **Focus:** God-tier scaling, Echo Point grinding, Glitched items & Corrupted Infusions.
* **Base Weapon Damage:** 500 – 1,200+
* **Base Armor (Per Piece):** 300 – 600+
* **Modifier Values:** Core Stats (+150 to +300+), Health (+1,000+), Resistances (Capped at 75%).
* **Equip Rules:** Requires the 3rd Job Change (Pinnacle Class). These items push the boundaries of the game's math and allow the player to survive the "Unallocated Space" (Act 5).
* **Corrupted Item Drops:** Defeating post-Echo Quest bosses and navigating corrupted rift nodes gives drops a chance to infuse an extra **Glitched Modifier** onto Legendary and Set items, creating hybrid power spikes.

---

## 5. Core Attributes & Modifier Types

When generating a Magic, Rare, or Legendary item, the `LootGenerator` will randomly select from these modifier categories based on the Item Base's Affix Pool.

* **Primary Attributes:**
* *Strength:* Increases Physical Damage (Swords/Axes/Maces) and Total Armor.
* *Agility:* Increases Ranged/Finesse Damage (Daggers/Bows) and Evasion.
* *Intelligence:* Increases Magic Damage and Maximum Mana/Secondary Resource scaling.
* *Stamina:* Increases Maximum HP (+10 HP per STA) and Total Armor (+1 Armor per 4 STA).

* **Offensive Modifiers:**
* * Flat Elemental Damage (Fire, Ice, Poison, Void, Lightning).
* * % Critical Hit Chance (Cap: 75%).
* * % Critical Hit Damage (Base is 150%).
* * % Attack Speed / Cast Speed.
* * % Boss Damage (Multiplicative damage against Echoes).
* * % Life Steal (Heal for a % of damage dealt).

* **Defensive Modifiers:**
* * Flat Armor or + % Total Armor.
* * Flat Max HP or + % Total HP.
* * % Elemental Resistances (Fire, Ice, Poison, Void, Lightning, Water - Cap: 75%).
* * % All Resistances (Capped at 75%).
* * Flat Damage Reflect (Thorns - Deals damage back when struck).
* * % Evasion (Chance to dodge an attack completely).
* * Range / Melee Avoidance (Chance to avoid taking melee counter-attack damage).

* **Utility & Resource Modifiers:**
* * % Magic Find (Increases the chance an item rolls as Rare or Legendary).
* * % Gold Drop Rate.
* * % EXP Gained.
* * % Cooldown Reduction (Reduces skill turn cooldowns).
* * Class Secondary Resource Boosts:
  * Vagabond: +Grit Generation (+1 to +5 Grit on turn/attack)
  * Juggernaut: +Fury Generation (+2 to +8 Fury on hit)
  * Phantom: +Max Energy (+10 to +30 Energy) / Energy Regen
  * Weaver: +Max Mana (+20 to +150 Mana) / Mana Regen
  * Warden: +Animus Resonance (+5 to +20 Animus capacity)

---

## 6. The Gem & Artisan Socketing Mechanics (Option B: Pure Modifiers & Artificer NPC)

In *Vagabond Hero*, **items drop purely with authentic combat and utility modifiers**—sockets never dilute or consume an item's modifier budget. Instead, sockets are physical sockets added post-drop through the camp/town artisan.

### 1. Natural Item Drops (Zero Intrinsic Sockets)
* All dropped and vendor equipment starts with **0 open sockets**.
* Rare, Unique, Legendary, and Set pieces always drop with their **full allocation of stat affixes** (+Strength, +Crit Chance, % Resistances, Unique Traits) without losing an affix slot to a socket roll.

### 2. The Artificer NPC: "Garrick's Drill & Infusion"
At the Vanguard's Hold (and Act Camp hubs), the **Artificer / Blacksmith NPC** provides equipment socketing services:
* **First Socket:** Costs Silver Prisms + Salvage Shards.
* **Second Socket:** Requires a higher level item (Level 35+) and Pristine Essences.
* **Maximum Socket Capacity by Slot:**
  * **2H Weapons & Torso (Chest):** Max **2 Sockets**.
  * **1H Weapons, Shields, Head, Legs:** Max **1 to 2 Sockets** (2nd socket unlocked at Level 50+).
  * **Arms, Waist, Feet, Neck, Rings:** Max **1 Socket**.

---

### 3. Gem Matrix & Slot Effects

Gems provide different stats based on where they are slotted:

| Gem Type | In Weapon (Offense) | In Armor / Head / Legs (Defense) | In Jewelry (Utility) |
| --- | --- | --- | --- |
| **Ruby (Fire)** | + Flat Fire Damage | + Flat Max HP | + % Fire Resistance |
| **Sapphire (Ice)** | + Flat Ice Damage | + Max Resource (Mana / Grit / Fury / Energy / Animus) | + % Ice Resistance |
| **Emerald (Poison)** | + Flat Poison Damage | + Flat Armor | + % Poison Resistance |
| **Amethyst (Void)** | + Flat Void Damage | + % Damage Reflect (Thorns) | + % Void Resistance |
| **Diamond (Core)** | + % Boss Damage | + % All Resistances | + % Magic Find |
| **Topaz (Wealth)** | + % Life Steal | + % Evasion | + % Gold Drop Rate |
| **Pearl (Swiftness)** | + % Attack Speed | + % Movement / Avoidance | + % EXP Gained |

**Gem Tier Combining (Blacksmith Forge):**
Players combine 3 gems of the same tier (plus gold) to upgrade them to the next tier:

1. **Chipped** (Lvl 1+)
2. **Flawed** (Lvl 15+)
3. **Regular** (Lvl 30+)
4. **Flawless** (Lvl 50+)
5. **Perfect** (Lvl 70)
6. **Radiant** (Act 5 / New Game+ Only)
