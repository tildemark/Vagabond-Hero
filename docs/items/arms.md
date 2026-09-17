# Vagabond Hero: Arms Slot Item Database

**File:** `item-arms.md`
**System:** Equipment Database (Levels 1 - 70)

This document contains the foundational database for all **Arms** slot items (Bracers, Gauntlets, Gloves, Armbands, Wraps) spanning Levels 1 to 70. This structure maps directly into the `ItemTemplates` and `ItemInstances` Drift database tables.

*Note: Arm items generally focus heavily on offensive utility modifiers, such as Attack Speed, Cast Speed, and Critical Hit Chance, alongside their defensive stats.*

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
| A-C01 | **Dirty Cloth Wraps** | Wraps | 1 | 1 - 3 | Simple rags wrapped around the hands to prevent blisters. |
| A-C02 | **Scavenger's Gloves** | Gloves | 5 | 3 - 6 | Thick leather gloves, useful for digging through the ash. |
| A-C03 | **Rusted Iron Bracers** | Bracers | 10 | 8 - 14 | Heavy forearm guards. The hinges are rusted stiff. |
| A-C04 | **Hardened Leather Armbands** | Armbands | 15 | 15 - 20 | Boiled leather reinforced with scrap metal. |
| A-C05 | **Vanguard's Gauntlets** | Gauntlets | 25 | 25 - 35 | Thick iron gloves that restrict finger movement but block blades. |
| A-C06 | **Silk-Woven Gloves** | Gloves | 35 | 40 - 55 | Extremely light, providing decent protection without sacrificing dexterity. |
| A-C07 | **Heavy Brass Bracers** | Bracers | 45 | 65 - 85 | Industrial forearm plating salvaged from old pumping machinery. |
| A-C08 | **Void-Glass Armguards** | Bracers | 55 | 100 - 130 | Forged from petrified fog. They hum with latent energy. |
| A-C09 | **Chrono-Steel Gauntlets** | Gauntlets | 65 | 160 - 200 | Interlocking gears over the knuckles allow for crushing strikes. |
| A-C10 | **Hard-Light Vambraces** | Bracers | 70 | 250 - 300 | Holographic shields that project outward from the wrists. |

---

## 2. Magic Items (1-2 Random Modifiers)

*Rolls modifiers from the Defense/Utility/Offense pool (Attack Speed, Core Stats, Resistances).*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| A-M01 | **Ash-Covered Gloves** | Gloves | 8 | 5 - 8 | +2 to 8 Core Stat<br>

<br>+2% to 5% Attack Speed | The ash makes the grip surprisingly secure. |
| A-M02 | **Cultist's Wraps** | Wraps | 22 | 20 - 28 | +10 to 20 Core Stat<br>

<br>+5% to 10% Cast Speed | Stained with strange, glowing ink. |
| A-M03 | **Kelp-Tangled Bracers** | Bracers | 38 | 45 - 60 | +25 to 40 Core Stat<br>

<br>+5% to 15% Water Resist | Slimy to the touch but highly resistant to pressure. |
| A-M04 | **Frost-Coated Gauntlets** | Gauntlets | 52 | 85 - 110 | +40 to 65 Core Stat<br>

<br>+2% to 5% Crit Chance | Leaves a trail of cold vapor when you swing your weapon. |
| A-M05 | **Data-Stream Armbands** | Armbands | 68 | 175 - 220 | +80 to 120 Core Stat<br>

<br>+5% to 10% Evasion | Code pulses rapidly up and down your forearms. |

---

## 3. Rare Items (3-4 Random Modifiers)

*These represent massive power spikes during leveling. Arms are primary sources for Attack Speed and Crit Chance.*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| A-R01 | **Defender's Vambraces** | Bracers | 18 | 15 - 22 | +15 to 25 STR/STA<br>

<br>+40 to 80 Max HP<br>

<br>+5 to 15 Damage Reflect<br>

| Excellent for blocking strikes in close-quarters combat. |
| A-R02 | **Shadow-Strike Gloves** | Gloves | 33 | 40 - 55 | +25 to 45 INT/AGI<br>

<br>+5% to 12% Attack Speed<br>

<br>+3% to 8% Crit Chance<br>

| Muffles the sound of your weapon being drawn. |
| A-R03 | **Hazardous Handling Gloves** | Gloves | 48 | 70 - 90 | +40 to 70 Core Stat<br>

<br>+15% to 30% Poison Resist<br>

<br>+10% to 20% Cast Speed<br>

| Thick rubberized material designed for handling toxic sludge. |
| A-R04 | **Engineer's Calibration** | Gloves | 62 | 130 - 165 | +70 to 110 Core Stat<br>

<br>+10% to 18% Attack Speed<br>

<br>+15% to 25% Magic Find<br>

| Fingers are lined with precision micro-tools. |
| A-R05 | **Mainframe Core-Guards** | Bracers | 70 | 260 - 320 | +120 to 180 Core Stat<br>

<br>+10% to 20% Crit Chance<br>

<br>+15% to 25% All Resist<br>

| Heat sinks vent directly from the wrists. |

---

## 4. Unique Items (4 Fixed Modifiers)

*Unique items drop from specific Mini-Bosses. They do NOT roll random modifiers; instead, they have highly synergistic, static stats.*

| ID | Item Name | Type | Req Lvl | Fixed Armor | Fixed Modifiers (Static Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| A-U01 | **Broodmother's Silk-Wraps** | Wraps | 15 | 22 | +15 Agility<br>

<br>+10% Attack Speed<br>

<br>+15% Poison Resist<br>

<br>+3% Crit Chance | Thin, incredibly strong, and slightly sticky. |
| A-U02 | **Zealot's Iron Cuffs** | Bracers | 35 | 60 | +35 Intelligence<br>

<br>+15% Cast Speed<br>

<br>+10% Magic Damage<br>

<br>+5% Life Steal | Shackles once worn by the devout, now weaponized. |
| A-U03 | **Talon-Lord's Claws** | Gloves | 50 | 100 | +60 Strength<br>

<br>+15% Evasion<br>

<br>+10% Attack Speed<br>

<br>+10% Crit Damage | Tipped with jagged shards of pure lightning-glass. |
| A-U04 | **Drowned Enforcer's Fists** | Gauntlets | 65 | 185 | +100 Stamina<br>

<br>+400 Max HP<br>

<br>+20% Armor<br>

<br>+15 Damage Reflect | Heavy diving gloves reinforced with lead knuckles. |
| A-U05 | **Architect's Manipulators** | Gloves | 70 | 350 | +150 All Stats<br>

<br>+25% Attack/Cast Speed<br>

<br>+15% Boss Damage<br>

| Grants the wearer pixel-perfect precision. |

---

## 5. Legendary Items (4-5 Random Modifiers + 1 Unique Trait)

*The ultimate chase items. Rolls incredibly high random modifiers AND possesses one hard-coded Unique Trait that alters the rules of the game.*

| ID | Item Name | Type | Req Lvl | Base Armor | Legendary Modifier Ranges | The Unique Trait (Game-Changer) |
| --- | --- | --- | --- | --- | --- | --- |
| A-L01 | **Fists of the Ashen Forge** | Gauntlets | 20 | 30 - 40 | +20 to 40 Core Stat<br>

<br>+5% to 15% Attack Speed<br>

<br>+10% to 20% Fire Resist<br>

| **Ignite:** Every consecutive Physical attack against the same target increases your Attack Speed by 10% and adds flat Fire damage. Resets if you change targets. |
| A-L02 | **Abyssal Reach** | Wraps | 40 | 85 - 110 | +50 to 80 Core Stat<br>

<br>+10% to 20% Cast Speed<br>

<br>+20% to 35% Void Resist<br>

| **Spatial Tear:** Your melee attacks gain the 'Ranged' property. You no longer trigger enemy melee Counter-Attacks. |
| A-L03 | **Chimera's Paws** | Gloves | 55 | 140 - 180 | +80 to 120 STR & INT<br>

<br>+10% to 20% Crit Chance<br>

<br>+10% to 20% Life Steal<br>

| **Savage Toxin:** Critical Hits simultaneously apply both a Bleed (STR-based) and Poison (INT-based) DoT to the target. |
| A-L04 | **Ascendant's Ticking Bracers** | Bracers | 65 | 210 - 260 | +110 to 160 Core Stat<br>

<br>+15% to 25% All Resist<br>

<br>+15% to 25% Attack Speed<br>

| **Double Strike:** You have a 25% chance to instantly repeat your Basic Attack or Spell for 0 Mana. |
| A-L05 | **The Prime Hand** | Gauntlets | 70 | 380 - 450 | +180 to 250 Core Stat<br>

<br>+20% to 30% Crit Chance<br>

<br>+50% to 100% Crit Damage<br>

| **Fatal Error:** Critical Hits execute non-boss enemies instantly. Critical Hits against Bosses deal 300% damage instead of 150%. |

---

## Code Implementation Logic (Loot Generator)

When generating an arms instance (e.g., `A-L04` Ascendant's Ticking Bracers):

1. Roll Base Armor between the defined Min/Max values (210 - 260).
2. Determine the player's primary Core Stat (STR, AGI, INT) via Smart Loot and roll its value based on the Modifier Range (110 - 160).
3. Roll the remaining random modifiers (All Resist, Attack Speed).
4. Apply the Unique Trait (`Double Strike`) statically to the item instance JSON. In the `CombatEngine`, after the player resolves an attack, calculate a `Random().nextInt(100) < 25` check. If true, run the attack logic a second time and push both results to the combat log.
