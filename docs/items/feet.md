# Vagabond Hero: Feet Slot Item Database

**File:** `item-feet.md`
**System:** Equipment Database (Levels 1 - 70)

This document contains the foundational database for all **Feet** slot items (Shoes, Sandals, Boots, Sabatons) spanning Levels 1 to 70. This structure maps directly into the `ItemTemplates` and `ItemInstances` Drift database tables.

*Note: Feet items generally provide moderate Base Armor but are the primary source for Movement Speed, Evasion, and hazard-immunity modifiers.*

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
| F-C01 | **Ash-Covered Sandals** | Sandals | 1 | 1 - 3 | Simple leather straps over a hardened wooden sole. |
| F-C02 | **Scavenger's Boots** | Boots | 5 | 4 - 7 | Worn, cracked leather boots patched with twine. |
| F-C03 | **Rusted Iron Sabatons** | Sabatons | 10 | 10 - 16 | Heavy metal boots that echo loudly on stone surfaces. |
| F-C04 | **Hardened Leather Boots** | Boots | 15 | 18 - 24 | Thick, sturdy boots ideal for long treks through the fog. |
| F-C05 | **Vanguard's Steel Sabatons** | Sabatons | 25 | 32 - 42 | Standard-issue footwear for the Hold's heavy infantry. |
| F-C06 | **Silken Slippers** | Shoes | 35 | 45 - 60 | Surprisingly durable and completely silent when walking. |
| F-C07 | **Heavy Brass Treads** | Boots | 45 | 75 - 95 | Weighted diving boots with ribbed copper soles. |
| F-C08 | **Void-Weave Shoes** | Shoes | 55 | 110 - 140 | Shoes woven from ambient fog. They leave no footprints. |
| F-C09 | **Chrono-Steel Sabatons** | Sabatons | 65 | 170 - 210 | Outfitted with tiny stabilizing gyros in the heels. |
| F-C10 | **Holographic Treads** | Boots | 70 | 250 - 310 | Emits a hard-light platform beneath your feet with every step. |

---

## 2. Magic Items (1-2 Random Modifiers)

*Rolls modifiers from the Defense/Utility pool (Max HP, Movement Speed, Evasion, Core Stats).*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| F-M01 | **Ash-Stained Footwraps** | Shoes | 8 | 7 - 11 | +3 to 8 Core Stat<br>

<br>+3% to 8% Movement Speed | Bound tightly, these wraps provide excellent arch support. |
| F-M02 | **Cultist's Pacing Boots** | Boots | 22 | 24 - 32 | +10 to 20 Core Stat<br>

<br>+2% to 6% Evasion | Worn thin from endless, obsessive pacing in the chapel. |
| F-M03 | **Kelp-Tied Sandals** | Sandals | 38 | 60 - 75 | +25 to 40 Core Stat<br>

<br>+5% to 15% Water Resist | Slimy, but grants excellent traction on wet surfaces. |
| F-M04 | **Frost-Rimed Sabatons** | Sabatons | 52 | 100 - 130 | +40 to 65 Core Stat<br>

<br>+10% to 20% Ice Resist | The metal clings dangerously to bare skin. |
| F-M05 | **Data-Stream Sneakers** | Shoes | 68 | 190 - 240 | +80 to 120 Core Stat<br>

<br>+5% to 12% Movement Speed | Sleek, digital footwear that glides over the grid. |

---

## 3. Rare Items (3-4 Random Modifiers)

*These represent massive power spikes during leveling and are the primary source for Evasion and Movement Speed.*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| F-R01 | **Defender's Sabatons** | Sabatons | 18 | 20 - 28 | +15 to 25 STR/STA<br>

<br>+30 to 70 Max HP<br>

<br>+3% to 7% Armor<br>

| Spiked soles provide an unyielding defensive stance. |
| F-R02 | **Shadow-Step Boots** | Boots | 33 | 50 - 65 | +25 to 45 INT/AGI<br>

<br>+8% to 15% Evasion<br>

<br>+10% Movement Speed<br>

| The leather seems to absorb ambient sound. |
| F-R03 | **Hazard Waders** | Boots | 48 | 85 - 110 | +40 to 70 Core Stat<br>

<br>+15% to 30% Poison Resist<br>

<br>+10% to 20% HP Regen<br>

| Knee-high rubber waders designed for the toxic sumps. |
| F-R04 | **Engineer's Brass-Toes** | Boots | 62 | 145 - 185 | +70 to 110 Core Stat<br>

<br>+10% to 20% Evasion<br>

<br>+15% to 25% Magic Find<br>

| Reinforced with solid brass toe caps to prevent crushing. |
| F-R05 | **Mainframe Core-Treads** | Boots | 70 | 280 - 340 | +120 to 180 Core Stat<br>

<br>+400 to 700 Max HP<br>

<br>+15% to 25% All Resist<br>

| Server-grade grounding boots that negate static feedback. |

---

## 4. Unique Items (4 Fixed Modifiers)

*Unique items drop from specific Mini-Bosses. They do NOT roll random modifiers; instead, they have highly synergistic, static stats.*

| ID | Item Name | Type | Req Lvl | Fixed Armor | Fixed Modifiers (Static Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| F-U01 | **Broodmother's Claws** | Shoes | 15 | 25 | +15 Agility<br>

<br>+15% Movement Speed<br>

<br>+10% Evasion<br>

<br>+15% Poison Resist | Chitinous shoes that allow the wearer to grip vertical surfaces. |
| F-U02 | **Zealot's Penance Treads** | Sandals | 35 | 65 | +35 Intelligence<br>

<br>+100 Max Mana<br>

<br>+15% Movement Speed<br>

<br>+5% Life Steal | Lined with sharp stones to ensure every step is painful. |
| F-U03 | **Talon-Lord's Talons** | Boots | 50 | 115 | +60 Strength<br>

<br>+20% Evasion<br>

<br>+20% Attack Speed<br>

<br>+20% Lightning Resist | Massive bird-like claws that dig fiercely into the ground. |
| F-U04 | **Drowned Enforcer's Anchors** | Sabatons | 65 | 215 | +100 Stamina<br>

<br>+350 Max HP<br>

<br>+25% Armor<br>

<br>+30% Water Resist | Lead-filled boots that make dodging almost impossible. |
| F-U05 | **Architect's Levitation** | Shoes | 70 | 400 | +150 All Stats<br>

<br>+25% Movement Speed<br>

<br>+15% Boss Damage<br>

| Hovering a few inches off the ground entirely. |

---

## 5. Legendary Items (4-5 Random Modifiers + 1 Unique Trait)

*The ultimate chase items. Rolls incredibly high random modifiers AND possesses one hard-coded Unique Trait that alters the rules of the game.*

| ID | Item Name | Type | Req Lvl | Base Armor | Legendary Modifier Ranges | The Unique Trait (Game-Changer) |
| --- | --- | --- | --- | --- | --- | --- |
| F-L01 | **Treads of the Ashen Forge** | Boots | 20 | 35 - 50 | +20 to 40 Core Stat<br>

<br>+60 to 120 Max HP<br>

<br>+10% to 20% Fire Resist<br>

| **Scorched Earth:** You leave a trail of fire. Enemies that engage you in melee combat take 25% of your Strength as Fire damage per turn. |
| F-L02 | **Abyssal Flippers** | Shoes | 40 | 100 - 130 | +50 to 80 Core Stat<br>

<br>+15% to 25% Evasion<br>

<br>+20% to 35% Void Resist<br>

| **Unencumbered:** You are completely immune to environmental movement penalties and all slow/snare debuffs. |
| F-L03 | **Chimera's Paws** | Boots | 55 | 160 - 200 | +80 to 120 STR & INT<br>

<br>+250 to 450 Max HP<br>

<br>+10% to 20% Evasion<br>

| **Feral Leap:** Selecting the 'Flee' command in combat now executes a damaging leap attack instead, dealing 150% Physical damage before escaping. |
| F-L04 | **Ascendant's Spring-Heels** | Boots | 65 | 240 - 290 | +110 to 160 Core Stat<br>

<br>+15% to 25% All Resist<br>

<br>+20% to 30% Movement Speed<br>

| **Momentum:** Every time you successfully Evade an attack, your Critical Hit Chance is increased by 10% for your next turn. |
| F-L05 | **The Prime Steps** | Sabatons | 70 | 420 - 500 | +180 to 250 Core Stat<br>

<br>+600 to 1000 Max HP<br>

<br>+20% to 40% Magic Find<br>

| **Teleportation:** Your movement instantly transitions you between Rooms. You can bypass locked doors or environmental hazards without taking damage. |

---

## Code Implementation Logic (Loot Generator)

When generating a feet instance (e.g., `F-L04` Ascendant's Spring-Heels):

1. Roll Base Armor between the defined Min/Max values (240 - 290).
2. Determine the player's primary Core Stat (STR, AGI, INT) via Smart Loot and roll its value based on the Modifier Range (110 - 160).
3. Roll the remaining random modifiers (All Resist, Movement Speed).
4. Apply the Unique Trait (`Momentum`) statically to the item instance JSON. In the `CombatEngine`, when `calculateEvasion()` resolves to true, a temporary state variable `momentumBuff += 10` is applied to the player's crit formula for the subsequent turn.
