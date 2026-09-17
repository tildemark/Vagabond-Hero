# Vagabond Hero: Waist Slot Item Database

**File:** `item-waist.md`
**System:** Equipment Database (Levels 1 - 70)

This document contains the foundational database for all **Waist** slot items (Belts, Sashes, Girdles, Cords, Bandoliers) spanning Levels 1 to 70. This structure maps directly into the `ItemTemplates` and `ItemInstances` Drift database tables.

*Note: Waist items generally have lower base armor than Torso or Head slots, but they frequently roll utility modifiers like Potion Effectiveness, Cooldown Reduction, and Max Mana.*

## Rarity Rules

* **Common (White):** Base Armor only. (0 Random Modifiers).
* **Magic (Blue):** Minor stats. (1-2 Random Modifiers).
* **Rare (Yellow):** Strong stats. (3-4 Random Modifiers).
* **Unique (Purple):** Fixed drops from mini-bosses. (4 Fixed Modifiers, 0 Random).
* **Legendary (Orange):** God-tier stats. (4-5 Random Modifiers + 1 Fixed Unique Trait).

---

## 1. Common Items (0 Modifiers)

*These act as baseline progression gear, crafting materials, or vendor salvage.*

| ID | Item Name | Type | Req Lvl | Base Armor Range | Description |
| --- | --- | --- | --- | --- | --- |
| W-C01 | **Woven Grass Cord** | Cord | 1 | 1 - 2 | Dried, petrified grass twisted into a fragile rope. |
| W-C02 | **Tattered Cloth Sash** | Sash | 5 | 2 - 4 | A strip of torn fabric used to hold pants up. |
| W-C03 | **Cracked Leather Belt** | Belt | 10 | 5 - 8 | Stiff, uncomfortable, but features a rusted iron buckle. |
| W-C04 | **Rusted Chain Girdle** | Girdle | 15 | 8 - 12 | Heavy metal links that clink loudly when you walk. |
| W-C05 | **Vanguard's Utility Belt** | Belt | 25 | 15 - 22 | Features numerous empty pouches for holding supplies. |
| W-C06 | **Spun-Silk Sash** | Sash | 35 | 25 - 35 | Surprisingly strong for being so thin and lightweight. |
| W-C07 | **Diver's Weight Belt** | Belt | 45 | 35 - 50 | Lined with heavy lead blocks to counteract buoyancy. |
| W-C08 | **Void-Thread Cord** | Cord | 55 | 55 - 75 | Woven from the ambient digital fog; feels cold to the touch. |
| W-C09 | **Brass-Geared Girdle** | Girdle | 65 | 85 - 110 | Interlocking brass plates that adjust to your breathing. |
| W-C10 | **Hard-Light Belt** | Belt | 70 | 130 - 160 | A floating band of holograms that locks around your waist. |

---

## 2. Magic Items (1-2 Random Modifiers)

*Rolls modifiers from the Defense/Utility pool (Max HP, Resistances, Core Stats, Mana).*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| W-M01 | **Ash-Dusted Sash** | Sash | 8 | 4 - 6 | +2 to 8 Core Stat<br>

<br>+10 to 20 Max HP | The grey ash seems permanently fused to the fabric. |
| W-M02 | **Cultist's Rope** | Cord | 22 | 12 - 16 | +10 to 20 Core Stat<br>

<br>+15 to 40 Max Mana | Used in dark rituals; it hums with dark magic. |
| W-M03 | **Brine-Soaked Belt** | Belt | 38 | 28 - 38 | +20 to 35 Core Stat<br>

<br>+5% to 15% Water Resist | Dripping wet and encrusted with glowing barnacles. |
| W-M04 | **Frost-Bitten Girdle** | Girdle | 52 | 50 - 65 | +35 to 60 Core Stat<br>

<br>+10% to 20% Ice Resist | The leather is stiff from absolute zero temperatures. |
| W-M05 | **Data-Stitched Sash** | Sash | 68 | 100 - 125 | +70 to 110 Core Stat<br>

<br>+5% to 10% Evasion | Flowing green code constantly scrolls across the cloth. |

---

## 3. Rare Items (3-4 Random Modifiers)

*These represent massive power spikes during leveling and form the backbone of mid-game builds. Belts often roll potion and utility buffs.*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| W-R01 | **Mercenary's Girdle** | Girdle | 18 | 10 - 15 | +10 to 20 STR/STA<br>

<br>+30 to 60 Max HP<br>

<br>+2% to 5% Armor<br>

<br>+1 Socket | A thick leather belt reinforced with iron studs. |
| W-R02 | **Shadow-Step Sash** | Sash | 33 | 22 - 30 | +20 to 40 INT/AGI<br>

<br>+5% to 10% Evasion<br>

<br>+40 to 100 Max Mana<br>

<br>+1 Socket | Makes your footsteps completely silent. |
| W-R03 | **Alchemist's Bandolier** | Belt | 48 | 40 - 55 | +35 to 65 Core Stat<br>

<br>+15% to 30% Potion Effect<br>

<br>+10% to 20% HP Regen<br>

<br>+1 to 2 Sockets | Covered in padded vials and glass tubes. |
| W-R04 | **Chrono-Mechanic's Belt** | Belt | 62 | 75 - 95 | +60 to 100 Core Stat<br>

<br>+10% to 20% Cooldown Reduc.<br>

<br>+15% to 25% Magic Find<br>

<br>+1 to 2 Sockets | Contains an array of miniature ticking clocks and tools. |
| W-R05 | **Mainframe Core-Cord** | Cord | 70 | 140 - 170 | +100 to 160 Core Stat<br>

<br>+300 to 600 Max HP<br>

<br>+15% to 25% All Resist<br>

<br>+2 Sockets | A thick fiber-optic cable ripped directly from a server. |

---

## 4. Unique Items (4 Fixed Modifiers)

*Unique items drop from specific Mini-Bosses. They do NOT roll random modifiers; instead, they have highly synergistic, static stats.*

| ID | Item Name | Type | Req Lvl | Fixed Armor | Fixed Modifiers (Static Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| W-U01 | **The Broodmother's Spinneret** | Sash | 15 | 15 | +15 Agility<br>

<br>+40 Max HP<br>

<br>+15% Poison Resist<br>

<br>+10% Movement Speed | Binds tightly to the wearer, secreting a faint paralyzing toxin. |
| W-U02 | **Zealot's Chains** | Girdle | 35 | 35 | +30 Intelligence<br>

<br>+100 Max Mana<br>

<br>+10% Magic Damage<br>

<br>+10% Cooldown Reduction | Heavy, rusted iron chains worn as a twisted form of penance. |
| W-U03 | **Talon-Lord's Binding** | Cord | 50 | 60 | +50 Strength<br>

<br>+15% Evasion<br>

<br>+10% Attack Speed<br>

<br>+20% Lightning Resist | Woven from razor-sharp glass fibers that spark when rubbed. |
| W-U04 | **Drowned Enforcer's Anchor** | Belt | 65 | 105 | +90 Stamina<br>

<br>+400 Max HP<br>

<br>+20% Armor<br>

<br>+30% Water Resist | An actual ship's chain wrapped multiple times around the waist. |
| W-U05 | **Architect's Tool-Belt** | Belt | 70 | 190 | +130 All Stats<br>

<br>+15% Boss Damage<br>

<br>+25% Potion Effect<br>

<br>+2 Sockets | Contains holographic tools that phase into reality when needed. |

---

## 5. Legendary Items (4-5 Random Modifiers + 1 Unique Trait)

*The ultimate chase items. Rolls incredibly high random modifiers AND possesses one hard-coded Unique Trait that alters the rules of the game.*

| ID | Item Name | Type | Req Lvl | Base Armor | Legendary Modifier Ranges | The Unique Trait (Game-Changer) |
| --- | --- | --- | --- | --- | --- | --- |
| W-L01 | **Ring of the Ashen Forge** | Girdle | 20 | 18 - 24 | +20 to 40 Core Stat<br>

<br>+60 to 120 Max HP<br>

<br>+10% to 20% Fire Resist<br>

<br>+1 Socket | **Ember Flask:** Whenever you use a healing potion, you unleash a shockwave of Fire Damage equal to 100% of your Strength to all enemies. |
| W-L02 | **Abyssal Trench-Belt** | Belt | 40 | 45 - 60 | +40 to 75 Core Stat<br>

<br>+150 to 250 Max Mana<br>

<br>+20% to 35% Void Resist<br>

<br>+1 to 2 Sockets | **Crush Depth:** Enemies that begin their turn in the same room as you have their Evasion and Attack Speed permanently reduced by 15%. |
| W-L03 | **Chimera's Coiled Tail** | Cord | 55 | 75 - 95 | +70 to 110 STR & INT<br>

<br>+250 to 450 Max HP<br>

<br>+10% to 20% Life Steal<br>

<br>+1 to 2 Sockets | **Beast Blood:** Potion effects and base HP regeneration are multiplied by 300%, but your base Armor is reduced by 25%. |
| W-L04 | **Ascendant's Pendulum** | Sash | 65 | 115 - 140 | +100 to 150 Core Stat<br>

<br>+15% to 25% All Resist<br>

<br>+15% to 25% Cooldown Reduc.<br>

<br>+2 Sockets | **Tick-Tock:** Every 3rd attack you make instantly reduces the cooldown of all your active skills by 1 turn. |
| W-L05 | **The Prime Loop** | Belt | 70 | 200 - 240 | +150 to 220 Core Stat<br>

<br>+600 to 900 Max HP<br>

<br>+25% to 45% Magic Find<br>

<br>+2 to 3 Sockets | **Memory Leak:** Every attack you land steals 5% of the enemy's maximum damage output and adds it to your own for the remainder of the battle. |

---

## Code Implementation Logic (Loot Generator)

When generating a waist instance (e.g., `W-L01` Ring of the Ashen Forge):

1. Roll Base Armor between the defined Min/Max values (18 - 24).
2. Determine the player's primary Core Stat (STR, AGI, INT) via Smart Loot and roll its value based on the Modifier Range (20 - 40).
3. Roll the remaining random modifiers (HP, Fire Resist, Sockets - Waist items typically favor 1 to 2 sockets).
4. Apply the Unique Trait (`Ember Flask`) statically to the item instance JSON for the `CombatEngine` to parse. Whenever the player triggers the "Use Potion" action, the engine checks for this trait flag and executes the AoE damage function.
