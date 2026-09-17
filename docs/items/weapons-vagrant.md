# Vagabond Hero: Early-Game Weapons & Shields Database

**File:** `item-weapons-tier1.md`
**System:** Equipment Database (Phase 1: Levels 1 - 20)

This document contains the foundational database for all **Weapons (1H and 2H)** and **Off-Hand Shields** strictly for the early-game progression bracket (Levels 1 to 20). This structure maps directly into the `ItemTemplates` and `ItemInstances` Drift database tables.

*Note: Equipping a 2H Weapon automatically locks the Off-Hand (Shield) slot in the UI. Shields provide Base Armor instead of Base Damage.*

## Rarity Rules (Levels 1-20 Scaling)

* **Common (White):** Base Damage or Base Armor only. (0 Random Modifiers).
* **Magic (Blue):** Minor stats. (1-2 Random Modifiers).
* **Rare (Yellow):** Strong stats. (3-4 Random Modifiers).
* **Unique (Purple):** Fixed drops from Act 1 mini-bosses. (4 Fixed Modifiers, 0 Random).
* **Legendary (Orange):** Ultimate Act 1 chase items. (4-5 Random Modifiers + 1 Fixed Unique Trait).

---

## 1. Common Items (0 Modifiers)

*Baseline progression gear. Drops frequently from basic Void-Rats and Cultists.*

| ID | Item Name | Type (Slot) | Req Lvl | Base Stat Range | Description |
| --- | --- | --- | --- | --- | --- |
| W1-C01 | **Rusted Iron Shiv** | 1H Dagger | 1 | 2 - 4 Dmg | A brittle blade scavenged from a corpse. |
| W1-C02 | **Splintered Branch** | 2H Staff | 2 | 4 - 7 Dmg | Heavy and unwieldy, but it crushes skulls well enough. |
| W1-C03 | **Dented Pot Lid** | Shield | 3 | 2 - 3 Armor | Better than blocking with your bare forearm. |
| W1-C04 | **Bent Copper Sword** | 1H Sword | 5 | 5 - 8 Dmg | The edge is dull, acting more like a club than a blade. |
| W1-C05 | **Frayed Shortbow** | 2H Bow | 7 | 6 - 10 Dmg | The string looks ready to snap at any moment. |
| W1-C06 | **Wooden Target Shield** | Shield | 9 | 6 - 9 Armor | Bound in rusted iron rings. |
| W1-C07 | **Heavy Iron Cleaver** | 1H Axe | 12 | 9 - 14 Dmg | Used by the butchers of old Oakhaven. |
| W1-C08 | **Ash-Wood Staff** | 2H Staff | 15 | 14 - 19 Dmg | The wood is petrified, making it incredibly dense. |
| W1-C09 | **Trainee's Buckler** | Shield | 18 | 12 - 16 Armor | Standard issue for new recruits at the Vanguard's Hold. |
| W1-C10 | **Forged Steel Longsword** | 2H Sword | 20 | 18 - 24 Dmg | A clean, sharp blade forged by Garrick the Smith. |

---

## 2. Magic Items (1-2 Random Modifiers)

*Rolls minor offensive and defensive modifiers to help players specialize before their Level 20 Job Change.*

| ID | Item Name | Type (Slot) | Req Lvl | Base Stat | Modifier Ranges (1 to 2 Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| W1-M01 | **Glowing Spore Wand** | 1H Wand | 4 | 4 - 7 Dmg | +2 to 5 Intelligence<br>

<br>+5 to 15 Max Mana | Emits a faint blue bioluminescence in the dark. |
| W1-M02 | **Brine-Soaked Buckler** | Shield | 8 | 5 - 8 Armor | +3 to 8 Strength<br>

<br>+2% to 5% Block Chance | Smells of the sea, even in the middle of the ash plains. |
| W1-M03 | **Cultist's Dagger** | 1H Dagger | 12 | 8 - 12 Dmg | +5 to 12 Agility<br>

<br>+2% to 5% Crit Chance | The blade is serrated and stained with dried blood. |
| W1-M04 | **Iron-Tipped Pike** | 2H Spear | 16 | 14 - 20 Dmg | +8 to 15 Core Stat<br>

<br>+5% to 10% Attack Speed | Keeps feral Void-beasts at a safe distance. |
| W1-M05 | **Void-Touched Mace** | 1H Mace | 20 | 12 - 17 Dmg | +10 to 20 Core Stat<br>

<br>+5 to 12 Flat Void Dmg | The head of the mace phases slightly out of reality. |

---

## 3. Rare Items (3-4 Random Modifiers)

*These represent massive power spikes for Act 1 and are usually kept until the mid-game of Act 2.*

| ID | Item Name | Type (Slot) | Req Lvl | Base Stat | Modifier Ranges (3 to 4 Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| W1-R01 | **Defender's Kite Shield** | Shield | 5 | 8 - 12 Armor | +5 to 10 STR/STA<br>

<br>+20 to 40 Max HP<br>

<br>+3% to 6% Block<br>

<br>+1 Socket | Painted with the faded crest of a forgotten kingdom. |
| W1-R02 | **Shadow-Strike Dirk** | 1H Dagger | 10 | 10 - 15 Dmg | +8 to 15 AGI<br>

<br>+4% to 8% Crit Chance<br>

<br>+10% to 20% Crit Dmg<br>

<br>+1 Socket | The blade absorbs light, creating a localized shadow. |
| W1-R03 | **Weaver's Silk-Bow** | 2H Bow | 15 | 16 - 22 Dmg | +12 to 22 AGI/INT<br>

<br>+10% to 15% Attack Speed<br>

<br>+5 to 15 Flat Poison Dmg<br>

<br>+1 Socket | Strung with incredibly tense spider silk. |
| W1-R04 | **Engraved Brass Hammer** | 1H Mace | 18 | 15 - 20 Dmg | +15 to 25 STR<br>

<br>+5% to 10% Armor<br>

<br>+10% to 20% Boss Dmg<br>

<br>+1 Socket | A heavy industrial tool repurposed for crushing skulls. |
| W1-R05 | **Hazard-Prod** | 2H Spear | 20 | 20 - 28 Dmg | +18 to 28 Core Stat<br>

<br>+15% to 25% Poison Resist<br>

<br>+10 to 20 Flat Lightning Dmg<br>

<br>+1 to 2 Sockets | Originally used to corral toxic sludge-beasts. |

---

## 4. Unique Items (4 Fixed Modifiers)

*Fixed static drops from specific Act 1 Mini-Bosses. Highly synergistic.*

| ID | Item Name | Type (Slot) | Req Lvl | Fixed Base | Fixed Modifiers (Static Rolls) | Description |
| --- | --- | --- | --- | --- | --- | --- |
| W1-U01 | **Void-Rat's Incisor** | 1H Dagger | 5 | 12 Dmg | +10 Agility<br>

<br>+5% Attack Speed<br>

<br>+10% Poison Resist<br>

<br>+5% Life Steal | Disgusting, but highly effective for quick, bleeding strikes. |
| W1-U02 | **Broodmother's Fang** | 1H Sword | 10 | 18 Dmg | +15 STR / AGI<br>

<br>+15 Flat Poison Dmg<br>

<br>+10% Crit Chance<br>

<br>+20% Crit Damage | Constantly drips a highly acidic, glowing venom. |
| W1-U03 | **Zealot's Iron Censer** | 2H Mace | 14 | 28 Dmg | +25 Strength<br>

<br>+20 Flat Fire Dmg<br>

<br>+15% Area of Effect Dmg<br>

<br>-10% Attack Speed (Debuff) | Swings slowly, but hits with the force of a meteor. |
| W1-U04 | **Harpy's Wing-Shield** | Shield | 17 | 25 Armor | +20 Agility<br>

<br>+10% Evasion<br>

<br>+10% Movement Speed<br>

<br>+20% Lightning Resist | A shield made of glass feathers that deflects both blades and magic. |
| W1-U05 | **Hollow Woodsman's Axe** | 2H Axe | 20 | 35 Dmg | +35 Strength<br>

<br>+25% Boss Damage<br>

<br>+15% Armor Penetration<br>

<br>+1 Socket | The very axe that tore the fabric of Act 1 apart. |

---

## 5. Legendary Items (4-5 Random Modifiers + 1 Unique Trait)

*The ultimate Act 1 chase items. These will easily carry a player deep into Act 2.*

| ID | Item Name | Type (Slot) | Req Lvl | Base Stat | Legendary Modifier Ranges | The Unique Trait (Game-Changer) |
| --- | --- | --- | --- | --- | --- | --- |
| W1-L01 | **Spark of the Ashen Forge** | 1H Mace | 10 | 14 - 19 Dmg | +15 to 25 STR/INT<br>

<br>+5% to 10% Crit Chance<br>

<br>+10 to 20 Flat Fire Dmg<br>

<br>+1 Socket | **Ignition:** Critical Hits ignite the enemy, dealing an additional 50% of the initial hit's damage over 2 turns. |
| W1-L02 | **The Whispering Web** | 2H Bow | 14 | 20 - 26 Dmg | +20 to 30 AGI<br>

<br>+10% to 20% Attack Speed<br>

<br>+15% to 25% Poison Resist<br>

<br>+1 to 2 Sockets | **Entangle:** Your basic attacks have a 20% chance to root the enemy, preventing them from using Evasion for 3 turns. |
| W1-L03 | **Vanguard's First Wall** | Shield | 16 | 20 - 28 Armor | +25 to 35 STR/STA<br>

<br>+100 to 150 Max HP<br>

<br>+5% to 15% Block Chance<br>

<br>+1 to 2 Sockets | **Phalanx:** While equipped, your active Companion takes 50% less damage from all sources. |
| W1-L04 | **Blade of the Severance** | 1H Sword | 18 | 22 - 30 Dmg | +30 to 45 Core Stat<br>

<br>+15% to 25% Crit Damage<br>

<br>+15 to 30 Flat Void Dmg<br>

<br>+1 to 2 Sockets | **Glitch-Strike:** 10% chance on hit to instantly deal damage equal to 15% of the enemy's Current HP (bypasses armor). |
| W1-L05 | **The Behemoth's Root** | 2H Staff | 20 | 28 - 38 Dmg | +40 to 60 INT<br>

<br>+100 to 200 Max Mana<br>

<br>+15% to 25% Cast Speed<br>

<br>+2 Sockets | **Overgrowth:** Casting a spell heals you for 10% of your Max HP. If you are at full HP, it grants a temporary armor shield instead. |

---

## Code Implementation Logic (Loot Generator)

When generating a weapon instance (e.g., `W1-L04` Blade of the Severance):

1. Roll Base Damage between the defined Min/Max values (22 - 30).
2. Determine the player's primary Core Stat via Smart Loot and roll its value based on the Modifier Range (30 - 45).
3. Roll the remaining random modifiers (Crit Damage, Void Dmg, Sockets).
4. Apply the Unique Trait (`Glitch-Strike`) statically to the item instance JSON.
5. In the `CombatEngine`, inside the `executePlayerTurn()` function, add a trait check:

```dart
if (weapon.trait == 'Glitch-Strike' && Random().nextDouble() <= 0.10) {
    int bonusDamage = (enemy.currentHp * 0.15).round();
    totalDamage += bonusDamage;
    combatLog.add('Your blade glitches through reality for $bonusDamage bonus damage!');
}
