# Vagabond Hero: Legs Slot Item Database

**File:** `item-legs.md`
**System:** Equipment Database (Levels 1 - 70)

This document contains the foundational database for all **Legs** slot items (Pants, Greaves, Legguards, Skirts, Trousers) spanning Levels 1 to 70. This structure maps directly into the `ItemTemplates` and `ItemInstances` Drift database tables.

*Note: Legs generally provide the second-highest Base Armor (behind the Torso) and frequently roll modifiers associated with Movement Speed, Evasion, and Maximum HP.*

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
| L-C01 | **Ash-Stained Pants** | Pants | 1 | 2 - 4 | Stiff with dried mud and grey ash. |
| L-C02 | **Scavenger's Trousers** | Trousers | 5 | 5 - 9 | Thick canvas that prevents the local flora from tearing up your legs. |
| L-C03 | **Rusted Iron Greaves** | Greaves | 10 | 14 - 20 | Heavy and clunky, significantly slowing the wearer's stride. |
| L-C04 | **Hardened Leather Legguards** | Legguards | 15 | 22 - 28 | Cured leather plates strapped tightly over padded trousers. |
| L-C05 | **Vanguard's Plate Legs** | Greaves | 25 | 38 - 50 | Sturdy iron armor issued to the defenders of the Hold. |
| L-C06 | **Silken Skirt** | Skirt | 35 | 55 - 75 | Woven from spider silk, offering surprisingly high tensile strength. |
| L-C07 | **Heavy Brass Cuisses** | Cuisses | 45 | 85 - 110 | Thick industrial thigh guards designed to withstand extreme pressure. |
| L-C08 | **Void-Weave Pants** | Pants | 55 | 130 - 165 | Fabric that seems to absorb the ambient light around it. |
| L-C09 | **Chrono-Steel Greaves** | Greaves | 65 | 200 - 250 | Emits a rhythmic mechanical whir with every step you take. |
| L-C10 | **Holographic Legguards** | Legguards | 70 | 300 - 360 | Project overlapping geometric shields around the wearer's legs. |

---

## 2. Magic Items (1-2 Random Modifiers)

*Rolls modifiers from the Defense/Utility pool (Max HP, Movement Speed, Evasion, Core Stats).*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| L-M01 | **Ash-Caked Trousers** | Trousers | 8 | 9 - 14 | +3 to 8 Core Stat<br>

<br>+2% to 5% Movement Speed | The ash coating strangely dampens the sound of your footsteps. |
| L-M02 | **Cultist's Skirt** | Skirt | 22 | 30 - 40 | +10 to 20 Core Stat<br>

<br>+20 to 50 Max Mana | The hem is stained with glowing blue void-fluid. |
| L-M03 | **Kelp-Woven Legguards** | Legguards | 38 | 70 - 90 | +25 to 40 Core Stat<br>

<br>+5% to 15% Water Resist | Clings uncomfortably tight but repels the crushing deep. |
| L-M04 | **Frost-Rimed Greaves** | Greaves | 52 | 120 - 150 | +40 to 65 Core Stat<br>

<br>+5% to 10% Evasion | The joints are stiff with ice, forcing a rigid posture. |
| L-M05 | **Data-Stream Pants** | Pants | 68 | 230 - 280 | +80 to 120 Core Stat<br>

<br>+5% to 10% Movement Speed | Vertical lines of code constantly cascade down the fabric. |

---

## 3. Rare Items (3-4 Random Modifiers)

*These represent massive power spikes during leveling and form the backbone of mid-game builds.*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| L-R01 | **Defender's Greaves** | Greaves | 18 | 25 - 35 | +15 to 25 STR/STA<br>

<br>+50 to 90 Max HP<br>

<br>+2% to 6% Armor<br>

<br>+1 to 2 Sockets | Battle-scarred leg plates that have seen countless skirmishes. |
| L-R02 | **Shadow-Step Trousers** | Trousers | 33 | 60 - 80 | +25 to 45 INT/AGI<br>

<br>+5% to 12% Evasion<br>

<br>+10% Movement Speed<br>

<br>+1 to 2 Sockets | The fabric blurs when you move, making you hard to target. |
| L-R03 | **Hazard Suit Legs** | Legguards | 48 | 100 - 130 | +40 to 70 Core Stat<br>

<br>+15% to 30% Poison Resist<br>

<br>+10% to 20% HP Regen<br>

<br>+1 to 2 Sockets | Fully sealed with airtight rubberized joints. |
| L-R04 | **Engineer's Brass Trousers** | Trousers | 62 | 170 - 220 | +70 to 110 Core Stat<br>

<br>+10% to 20% Evasion<br>

<br>+15% to 25% Magic Find<br>

<br>+2 Sockets | Lined with copper wire to ground out electrical charges. |
| L-R05 | **Mainframe Core-Greaves** | Greaves | 70 | 330 - 400 | +120 to 180 Core Stat<br>

<br>+500 to 800 Max HP<br>

<br>+15% to 25% All Resist<br>

<br>+2 Sockets | High-density ceramic plates wired directly to the server core. |

---

## 4. Unique Items (4 Fixed Modifiers)

*Unique items drop from specific Mini-Bosses. They do NOT roll random modifiers; instead, they have highly synergistic, static stats.*

| ID | Item Name | Type | Req Lvl | Fixed Armor | Fixed Modifiers (Static Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| L-U01 | **Broodmother's Carapace Legs** | Legguards | 15 | 30 | +15 Agility<br>

<br>+50 Max HP<br>

<br>+10% Evasion<br>

<br>+15% Poison Resist | Chitinous plating that flexes naturally with the wearer's joints. |
| L-U02 | **Zealot's Tattered Skirt** | Skirt | 35 | 80 | +35 Intelligence<br>

<br>+120 Max Mana<br>

<br>+15% Movement Speed<br>

<br>+5% Life Steal | Torn and frayed, yet it sweeps across the floor without a sound. |
| L-U03 | **Talon-Lord's Greaves** | Greaves | 50 | 140 | +60 Strength<br>

<br>+15% Evasion<br>

<br>+20% Attack Speed<br>

<br>+20% Lightning Resist | Forged to resemble the powerful legs of a predatory bird. |
| L-U04 | **Drowned Enforcer's Cuisses** | Cuisses | 65 | 260 | +100 Stamina<br>

<br>+450 Max HP<br>

<br>+25% Armor<br>

<br>+30% Water Resist | So heavy they leave permanent indentations in the digital stone. |
| L-U05 | **Architect's Leg-Braces** | Legguards | 70 | 480 | +150 All Stats<br>

<br>+15% Boss Damage<br>

<br>+20% Movement Speed<br>

<br>+2 Sockets | Exoskeletal braces that entirely negate the effects of fatigue. |

---

## 5. Legendary Items (4-5 Random Modifiers + 1 Unique Trait)

*The ultimate chase items. Rolls incredibly high random modifiers AND possesses one hard-coded Unique Trait that alters the rules of the game.*

| ID | Item Name | Type | Req Lvl | Base Armor | Legendary Modifier Ranges | The Unique Trait (Game-Changer) |
| --- | --- | --- | --- | --- | --- | --- |
| L-L01 | **Greaves of the Ashen Forge** | Greaves | 20 | 45 - 60 | +20 to 40 Core Stat<br>

<br>+80 to 150 Max HP<br>

<br>+10% to 20% Fire Resist<br>

<br>+1 to 2 Sockets | **Unmovable:** You are completely immune to all Stun, Knockback, and Root debuffs. |
| L-L02 | **Abyssal Waders** | Pants | 40 | 120 - 160 | +50 to 80 Core Stat<br>

<br>+10% to 20% Evasion<br>

<br>+20% to 35% Void Resist<br>

<br>+2 Sockets | **Deep Current:** Whenever you successfully Evade an attack, your next action costs 0 Mana and does not consume your turn. |
| L-L03 | **Chimera's Hind Legs** | Legguards | 55 | 190 - 240 | +80 to 120 STR & INT<br>

<br>+300 to 500 Max HP<br>

<br>+10% to 15% Life Steal<br>

<br>+2 Sockets | **Predator's Pounce:** Your very first attack in any combat encounter deals 250% damage and guarantees a Critical Hit. |
| L-L04 | **Ascendant's Gear-Pants** | Trousers | 65 | 280 - 340 | +110 to 160 Core Stat<br>

<br>+15% to 25% All Resist<br>

<br>+15% to 25% Movement Speed<br>

<br>+2 Sockets | **Clockwork Steps:** For every turn that passes in combat, your Evasion increases by 2%, up to a maximum of 20%. |
| L-L05 | **The Prime Strides** | Greaves | 70 | 500 - 600 | +180 to 250 Core Stat<br>

<br>+800 to 1200 Max HP<br>

<br>+20% to 40% Magic Find<br>

<br>+2 to 3 Sockets | **System Bypass:** You are entirely immune to environmental damage, traps, and passive Node debuffs (e.g., Toxic drains, Chill effects). |

---

## Code Implementation Logic (Loot Generator)

When generating a legs instance (e.g., `L-L02` Abyssal Waders):

1. Roll Base Armor between the defined Min/Max values (120 - 160).
2. Determine the player's primary Core Stat (STR, AGI, INT) via Smart Loot and roll its value based on the Modifier Range (50 - 80).
3. Roll the remaining random modifiers (Evasion, Void Resist, Sockets).
4. Apply the Unique Trait (`Deep Current`) statically to the item instance JSON. In the `CombatEngine`, when the `calculateEvasion()` function returns true, the engine applies a temporary state flag `freeTurn = true`, skipping the enemy's next action and resetting the player's mana cost for the subsequent spell.
