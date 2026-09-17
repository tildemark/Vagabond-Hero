# Vagabond Hero: Complete Bestiary Database

**File:** `mobs.md`
**System:** Mob Templates, Scaling, and Act-by-Act Encounters

This document contains the complete bestiary for *Vagabond Hero*, covering enemy scaling formulas, Drift database schemas, and all mob types spanning Acts 1 through 5, including mini-bosses and final encounters.

---

## Part 1: The Drift Database Schema for Mobs

To support procedural room encounters, elite modifiers, and specific Act drops, the mob system is structured into static blueprints and active instances:

```dart
import 'package:drift/drift.dart';

class MobTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get actNumber => integer()(); // Act 1 to 5
  TextColumn get name => text()();
  TextColumn get mobType => text()(); // 'Beast', 'Undead', 'Construct', 'Daemon', 'Glitch'
  
  // Base scaling attributes per level
  IntColumn get minLevel => integer()();
  IntColumn get maxLevel => integer()();
  RealColumn get baseHpScaling => real()(); // Multiplier per level
  RealColumn get baseDamageScaling => real()();
  
  // Behavior flags stored as JSON: '["Aggressive", "CastsPoison", "ResistsFire"]'
  TextColumn get traitsJson => text()();
}
```

---

## Part 2: Mob Stat Scaling Formula

To ensure enemies dynamically match player progression, a mob's actual combat stats are computed upon entering a room, using the current Node level as the anchor:

$$\text{HP} = \text{BaseHP} \times \left(1 + (\text{MobLevel} \times \text{ScalingFactor})\right)^{1.2}$$
$$\text{Damage} = \text{BaseDamage} \times \left(1 + (\text{MobLevel} \times \text{ScalingFactor})\right)$$

---

## Part 3: Complete Bestiary by Act

### Act 1: The Ashen Woods (Levels 1 - 20)

*Theme: Organic corruption, feral wildlife, and early cultists. Teaches basic mechanics like Bleed and Poison.*

| Mob Name | Mob Type | Level Range | Signature Mechanics & Traits |
| :--- | :--- | :--- | :--- |
| **Void-Rat** | Beast | 1 - 5 | High attack speed, low HP. Applies stackable *Bleed* (Agility scaling). |
| **Ash-Stalker Wolf** | Beast | 2 - 8 | Packs of two spawn together. High attack speed; applies a minor movement slowdown debuff. |
| **Thorn-Back Crawler** | Beast | 7 - 14 | Features native 10% Armor. Reflects minor physical damage back to melee attackers. |
| **Corrupted Cultist** | Humanoid | 6 - 12 | Uses ranged magic bolts. Casts *Curse of Weakness* (-10% Strength for 2 turns). |
| **Hollow Heretic** | Humanoid | 12 - 20 | Casts slow-moving shadow bolts; sacrifices itself when below 10% HP to heal nearby mobs. |
| **The Whispering Broodmother** | Mini-Boss | 15 | Massive spider that spawns web tokens, locking out the player's Potion slot every 3 turns. |

---

### Act 2: The Sunken City (Levels 21 - 35)

*Theme: Water, pressure, and ancient ruins. Introduces high-armor enemies and elemental resistances.*

| Mob Name | Mob Type | Level Range | Signature Mechanics & Traits |
| :--- | :--- | :--- | :--- |
| **Drowned Diver** | Undead | 21 - 28 | Wields heavy anchors. High base armor; deals crushing physical damage. |
| **Barnacle-Encrusted Golem** | Construct | 21 - 28 | Extremely high Base Armor. Immune to Bleed; vulnerable to Lightning damage. |
| **Abyssal Jellyfish** | Daemon | 25 - 35 | Floats above melee range. Deals lightning/ice damage and has a 20% native Evasion chance. |
| **Siren of the Trench** | Undead | 25 - 33 | Casts *Sonic Wail*, forcing the player to skip their basic attack action on the next turn. |
| **Abyssal Crawler** | Beast | 28 - 35 | Applies a stacking *Chilled* debuff, reducing player Attack Speed by 5% per stack (Max 4 stacks). |
| **The Drowned Enforcer** | Mini-Boss | 35 | Applies the *Chilled* debuff, reducing player Attack Speed by 25%. |

---

### Act 3: The Clockwork Peaks (Levels 36 - 50)

*Theme: Steampunk mechanics, automated traps, and pure electricity.*

| Mob Name | Mob Type | Level Range | Signature Mechanics & Traits |
| :--- | :--- | :--- | :--- |
| **Clockwork Sentinel** | Construct | 36 - 45 | Immune to Poison and Bleed. Reflects 15% of physical melee damage back to the player. |
| **Steam-Driven Juggernaut** | Construct | 36 - 43 | Slow movement, but heavy physical strikes that ignore 15% of player armor. |
| **Aether-Spark Swarm** | Construct | 40 - 50 | Composed of tiny floating gears. Deals continuous multi-hit Lightning damage; high evasion. |
| **Aether-Drone** | Construct | 40 - 50 | Fires continuous lightning beams. Every 3rd turn, it self-repairs for 10% of its Max HP. |
| **Clockwork Sniper** | Construct | 45 - 50 | Takes 1 turn to charge a long-range shot, then deals massive Piercing damage on the 2nd turn. |
| **The Talon-Lord** | Mini-Boss | 50 | A massive glass-feathered predator with 50% Evasion that dives in and out of combat turns. |

---

### Act 4: The Astral Servers (Levels 51 - 70)

*Theme: Cosmic horror, pure code, and security daemons.*

| Mob Name | Mob Type | Level Range | Signature Mechanics & Traits |
| :--- | :--- | :--- | :--- |
| **Glass-Daemon** | Daemon | 51 - 60 | Fires razor-sharp light fragments that ignore 20% of player armor. |
| **Bit-Stream Serpent** | Daemon | 51 - 60 | A serpentine entity of pure light. Applies *Silence*, preventing the player from using active skills for 1 turn. |
| **Memory-Leak Spectre** | Undead | 58 - 65 | Drains 10% of the player's current Secondary Resource (Grit, Fury, Energy, Mana, or Animus) on every successful hit. |
| **Firewall Seraph** | Construct | 60 - 70 | Rings of eyes that cast hard-light shields on other mobs in the room. |
| **Packet-Storm Daemon** | Daemon | 63 - 70 | Periodically splits into two lesser daemons at 50% HP, forcing target prioritization. |
| **The Prime Override** | Final Boss | 70 | Mirrors player stats in Phase 1; initiates the 4-turn *Fatal Exception* instant-wipe timer in Phase 2. |

---

### Act 5: The Unallocated Space (New Game+ / Levels 70+)

*Theme: Broken physics, missing textures, and deleted assets.*

| Mob Name | Mob Type | Level Range | Signature Mechanics & Traits |
| :--- | :--- | :--- | :--- |
| **Asset-Chimera** | Glitch | 70+ | Randomly scrambles its type every turn (switching its immunities and damage profiles). |
| **Syntax-Crawler** | Glitch | 70+ | Consumes room resources; forces the player to clear them before attacking elites. |
| **Unrendered Polygon** | Glitch | 70+ | Flickers in and out of reality, granting it a permanent 30% Evasion chance. |
| **Corrupted Frame-Rate** | Glitch | 70+ | Slows down player inputs; every action has a 20% chance to be delayed to the following turn. |
| **Orphaned File** | Glitch | 70+ | A wandering cube of floating text strings that explodes upon defeat, dealing True Damage to all combatants. |
| **The Garbage Collector** | Final Boss | 70+ | Permanently deletes player UI buttons turn-by-turn until defeated. |
