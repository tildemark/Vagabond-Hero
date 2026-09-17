# Vagabond Hero: Torso Slot Item Database

**File:** `item-torso.md`
**System:** Equipment Database (Levels 1 - 70)

This document contains the foundational database for all **Torso** slot items (Chest Plates, Shirts, Robes, Harnesses, Coats) spanning Levels 1 to 70. This structure is designed to map directly into the `ItemTemplates` and `ItemInstances` Drift database tables.

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
| T-C01 | **Threadbare Shirt** | Shirt | 1 | 3 - 5 | A plain linen shirt, worn thin by the ash winds. |
| T-C02 | **Scavenger's Tunic** | Tunic | 5 | 8 - 12 | Thick, padded cloth that offers basic protection from bites and scratches. |
| T-C03 | **Rusted Chainmail** | Chainmail | 10 | 18 - 25 | The links are brittle and snap easily, but it beats bare skin. |
| T-C04 | **Hardened Leather Cuirass** | Cuirass | 15 | 28 - 35 | Cured with unnatural chemicals to resist the Void fog. |
| T-C05 | **Vanguard's Iron Plate** | Plate | 25 | 50 - 65 | Standard issue heavy armor forged in the Vanguard's Hold. |
| T-C06 | **Silken Spell-Coat** | Coat | 35 | 75 - 95 | Woven tightly from spider silk, it hums with latent energy. |
| T-C07 | **Heavy Brass Rigging** | Harness | 45 | 110 - 140 | An industrial exoskeleton frame used by deep-trench divers. |
| T-C08 | **Void-Weave Robes** | Robe | 55 | 170 - 210 | Fabric that phase-shifts slightly, making the wearer hard to focus on. |
| T-C09 | **Chrono-Steel Chestplate** | Plate | 65 | 260 - 310 | Emits a rhythmic ticking sound; the metal feels warm to the touch. |
| T-C10 | **Holographic Aegis** | Cuirass | 70 | 400 - 480 | A chest piece made entirely of hard-light polygons and projected code. |

---

## 2. Magic Items (1-2 Random Modifiers)

*Rolls modifiers from the Defense/Utility pool (Max HP, Resistances, Core Stats).*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| T-M01 | **Ash-Stained Jerkin** | Shirt | 8 | 12 - 18 | +4 to 10 Core Stat<br>

<br>+15 to 30 Max HP | The ash woven into the fabric seems to absorb minor impacts. |
| T-M02 | **Acolyte's Robe** | Robe | 22 | 40 - 52 | +15 to 25 Core Stat<br>

<br>+20 to 50 Max Mana | Worn by those who worship the geometry of the Severance. |
| T-M03 | **Kelp-Woven Harness** | Harness | 38 | 90 - 115 | +30 to 50 Core Stat<br>

<br>+10% to 20% Water Resist | Smells terrible, but repels the crushing depths of the Sunken City. |
| T-M04 | **Frost-Forged Chain** | Chainmail | 52 | 155 - 195 | +50 to 80 Core Stat<br>

<br>+5% to 15% Total Armor | The metal links are frozen solid, yet remain perfectly flexible. |
| T-M05 | **Data-Stream Coat** | Coat | 68 | 300 - 360 | +90 to 140 Core Stat<br>

<br>+8% to 15% Evasion | A long coat that trails off into cascading green binary code. |

---

## 3. Rare Items (3-4 Random Modifiers)

*These represent massive power spikes during leveling and form the backbone of mid-game builds. Torso items often roll the highest HP and socket counts.*

| ID | Item Name | Type | Req Lvl | Base Armor | Modifier Ranges | Description |
| --- | --- | --- | --- | --- | --- | --- |
| T-R01 | **Defender's Bastion** | Plate | 18 | 35 - 45 | +15 to 30 STR/STA<br>

<br>+60 to 100 Max HP<br>

<br>+5% to 10% Armor<br>

<br>+1 to 2 Sockets | A dented but incredibly sturdy piece of pre-Severance armor. |
| T-R02 | **Shadow-Cloak Tunic** | Tunic | 33 | 80 - 105 | +30 to 55 INT/AGI<br>

<br>+8% to 15% Evasion<br>

<br>+60 to 150 Max Mana<br>

<br>+1 to 2 Sockets | Absorbs ambient light, making the wearer difficult to track. |
| T-R03 | **Hazard Suit** | Harness | 48 | 130 - 165 | +50 to 85 Core Stat<br>

<br>+20% to 40% Poison Resist<br>

<br>+15% to 30% HP Regen<br>

<br>+2 to 3 Sockets | Heavy rubber and brass, built for the toxic aqueducts. |
| T-R04 | **Engineer's Boilerplate** | Plate | 62 | 220 - 270 | +80 to 130 Core Stat<br>

<br>+20% to 35% Fire Resist<br>

<br>+15% to 25% Magic Find<br>

<br>+2 to 3 Sockets | Fitted with exhaust valves that vent excess thermal energy. |
| T-R05 | **Mainframe Core-Suit** | Cuirass | 70 | 420 - 520 | +140 to 200 Core Stat<br>

<br>+600 to 1000 Max HP<br>

<br>+15% to 25% All Resist<br>

<br>+3 Sockets | A high-tech chassis that interfaces directly with your nervous system. |

---

## 4. Unique Items (4 Fixed Modifiers)

*Unique items drop from specific Mini-Bosses. They do NOT roll random modifiers; instead, they have highly synergistic, static stats.*

| ID | Item Name | Type | Req Lvl | Fixed Armor | Fixed Modifiers (Static Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| T-U01 | **Thorax of the Brood** | Cuirass | 15 | 40 | +20 Agility<br>

<br>+60 Max HP<br>

<br>+20% Poison Resist<br>

<br>+15 Damage Reflect (Thorns) | An exoskeleton ripped from a massive spider. Still twitches. |
| T-U02 | **Zealot's Penance** | Robe | 35 | 105 | +45 Intelligence<br>

<br>+150 Max Mana<br>

<br>+15% Magic Damage<br>

<br>+10% Cast Speed | Lined with sharp barbs on the inside to keep the wearer focused. |
| T-U03 | **Talon-Lord's Plumage** | Coat | 50 | 180 | +75 Strength<br>

<br>+20% Evasion<br>

<br>+15% Movement Speed<br>

<br>+25% Lightning Resist | A mantle of glass feathers that conduct electricity harmlessly away. |
| T-U04 | **Drowned Enforcer's Plate** | Plate | 65 | 320 | +120 Stamina<br>

<br>+600 Max HP<br>

<br>+30% Armor<br>

<br>+40% Water Resist | Enormously heavy; forces the wearer to walk with a lumbering gait. |
| T-U05 | **Architect's Matrix** | Harness | 70 | 600 | +180 All Stats<br>

<br>+15% Boss Damage<br>

<br>+20% Cooldown Reduction<br>

<br>+3 Sockets | A floating rig of server racks that orbits the wearer's torso. |

---

## 5. Legendary Items (4-5 Random Modifiers + 1 Unique Trait)

*The ultimate chase items. Rolls incredibly high random modifiers AND possesses one hard-coded Unique Trait that alters the rules of the game.*

| ID | Item Name | Type | Req Lvl | Base Armor | Legendary Modifier Ranges | The Unique Trait (Game-Changer) |
| --- | --- | --- | --- | --- | --- | --- |
| T-L01 | **Heart of the Forge** | Plate | 20 | 55 - 75 | +25 to 50 Core Stat<br>

<br>+100 to 200 Max HP<br>

<br>+15% to 30% Fire Resist<br>

<br>+1 to 2 Sockets | **Molten Core:** Enemies that strike you in melee are Ignited, taking Fire Damage equal to 10% of their Max HP over 3 turns. |
| T-L02 | **Mantle of the Abyss** | Robe | 40 | 150 - 190 | +60 to 100 Core Stat<br>

<br>+250 to 450 Max Mana<br>

<br>+20% to 40% Void Resist<br>

<br>+2 to 3 Sockets | **Void Siphon:** 30% of all damage you take is converted into Mana. If your Mana is full, the excess heals you instead. |
| T-L03 | **Chimera's Hide** | Coat | 55 | 240 - 300 | +90 to 140 STR & INT<br>

<br>+400 to 700 Max HP<br>

<br>+15% to 25% Life Steal<br>

<br>+2 to 3 Sockets | **Apex Hide:** You take 25% less damage from Bosses and Elite enemies. |
| T-L04 | **Ascendant's Gearbox** | Cuirass | 65 | 350 - 420 | +120 to 180 Core Stat<br>

<br>+20% to 30% All Resist<br>

<br>+15% to 25% Attack Speed<br>

<br>+2 to 3 Sockets | **Overclock:** Every time you take damage, your Attack Speed and Cast Speed increase by 10%. Stacks up to 5 times. Lasts until the end of combat. |
| T-L05 | **The Prime Shell** | Plate | 70 | 650 - 800 | +200 to 300 Core Stat<br>

<br>+1000 to 1500 Max HP<br>

<br>+25% to 50% Magic Find<br>

<br>+3 Sockets | **God Mode:** At the start of every combat encounter, you gain a hard-light shield equal to 100% of your Max HP. |

---

## Code Implementation Logic (Loot Generator)

When generating a torso instance (e.g., `T-L04` Ascendant's Gearbox):

1. Roll Base Armor between the defined Min/Max values (350 - 420).
2. Determine the player's primary Core Stat (STR, AGI, INT) via Smart Loot and roll its value based on the Modifier Range (120 - 180).
3. Roll the remaining random modifiers (All Resist, Attack Speed, Sockets - Torso items typically favor 2 to 3 sockets for high customizability).
4. Apply the Unique Trait (`Overclock`) statically to the item instance JSON for the `CombatEngine` to parse.
