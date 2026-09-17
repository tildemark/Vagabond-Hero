# Vagabond Hero: Character Mechanics & Skill Trees

**File:** `character-mechanics.md`
**System:** Class Evolution, Active Skills, and Endgame Progression

---

## 1. Progression & The Level 70 Pinnacle Quest

Character progression is strictly bracketed by Job Changes.

* **Levels 1 - 20:** Vagabond (Base).
* **Levels 21 - 50:** First Job Change (Base Specialization).
* **Levels 51 - 70:** Second Job Change (Advanced Specialization).
* **Level 70 (Max Level):** Progression halts until the **"Breaking the Core" Quest** is completed.
  * *The Quest:* The player must delve into the deepest part of Act 4 and defeat an over-leveled Echo boss without the use of potions.
  * *The Reward:* Unlocks the **Third Job Change (Pinnacle Class)**, activates the **Echo System** (infinite Paragon-style scaling), and grants the system permission to equip **Glitched (Red)** items.

---

## 2. Dynamic Class-Specific Secondary Resources

Unlike traditional RPGs that force all archetypes into a generic Mana pool, *Vagabond Hero* gives each class archetype a mechanically distinct resource with its own generation, expenditure, and HUD theme:

| Class Archetype | Resource Name | UI Theme & Color | Generation & Mechanics |
| :--- | :--- | :--- | :--- |
| **Vagabond** *(Survivor)* | **`Grit`** (0 – 100) | 🟤 Bronze (`#B45309`) | **Survival Willpower:** Starts at 50. Gains +10 per turn, +15 when struck, +5 on basic attack. Spent on survival maneuvers (*Patch Up*, *Desperate Flee*). |
| **Juggernaut** *(Strength)* | **`Fury`** (0 – 100) | 🔴 Molten Crimson (`#DC2626`) | **Combat Escalation:** Starts at 0. Generated when hitting enemies (+10) or taking hits (+15). Slowly decays out of combat (-10/room). Spent on devastating physical smashes. |
| **Phantom** *(Agility)* | **`Energy`** (0 – 100) | 🟡 Electric Amber (`#F59E0B`) | **High-Speed Stamina:** Starts full at 100. Regenerates rapidly (+25 per turn). Skills consume chunks of Energy for high-tempo combo chains. |
| **Weaver** *(Intelligence)* | **`Mana`** (0 – Max Mana) | 🔵 Arcane Azure (`#38BDF8`) | **Deep Arcane Reservoir:** Derived directly from Intelligence (Base 50 + INT * 5). Siphon and cycle spells manage this deep reserve for massive spell bursts. |
| **Warden** *(Summon/Utility)* | **`Animus`** (0 – 100) | 🟢 Emerald Life (`#10B981`) | **Pack Resonance:** Starts at 30. Generated when your Summon strikes (+15) or when leeching life from targets (+10). Sustains companions and nature barriers. |

### Subclass Evolution (2nd Job Awakening):
* **Berserker:** **`Bloodrage`** (Fury generation doubles when under 50% HP; skills can consume health for guaranteed crits).
* **Void-Knight:** **`Resolve`** (Generates resource directly from mitigated and reflected damage).
* **Assassin:** **`Energy + Combo Points`** (Build 1–5 combo points with Flurry, spend with Eviscerate).
* **Rift-Sniper:** **`Focus`** (Maximized by standing still, spent on massive charge shots).
* **Blood Mage:** **`Blood Essence`** (Completely replaces Mana with raw HP costs and overheal shields).
* **Elementalist:** **`Tri-Flux`** (Cycles Fire, Ice, and Lightning charges for spell resonance).

---

## 3. Phase 1: The Survivor (Levels 1 - 20)

All players start here. Skills are basic, focusing on surviving the initial encounters using **`Grit`** (0 – 100).

### Vagabond

* **[Lv 1] Scavenger's Strike:** A basic attack dealing 100% Weapon Damage. 10% chance to dislodge 1-5 Gold from the enemy. (Cost: 0 Grit, Generates +5 Grit, Cooldown: 0 Turns)
* **[Lv 5] Patch Up:** Restores 15% of Max HP. Cannot be used if Poisoned or Bleeding. (Cost: 30 Grit, Cooldown: 4 Turns)
* **[Lv 15] Desperate Flee:** Attempt to run from combat. 50% success rate. Fails automatically against Bosses. (Cost: 20 Grit, Cooldown: 1 Turn)

---

## 4. Phase 2: First Job Awakening (Levels 21 - 50)

At Level 20, the player selects one of four base classes. Combat shifts to utilizing class-specific resources (**Fury**, **Energy**, **Mana**, **Animus**) and managing turn cooldowns.

### Juggernaut (Strength Focus — Resource: `Fury` 0–100)

* **[Lv 21] Heavy Smash:** Deals 140% Physical Damage. Reduces enemy Evasion by 10% for 2 turns. (Cost: 20 Fury, Cooldown: 2 Turns)
* **[Lv 30] Taunt:** Forces the enemy to target you instead of your Companion. Increases your Armor by 25% for 3 turns. (Cost: 15 Fury, Generates +10 Fury when struck, Cooldown: 4 Turns)
* **[Lv 45] Earthshatter:** AoE attack. Deals 110% Physical Damage to all enemies in the room. (Cost: 40 Fury, Cooldown: 5 Turns)

### Phantom (Agility Focus — Resource: `Energy` 0–100)

* **[Lv 21] Flurry:** Strikes twice, each hit dealing 70% Finesse Damage. High chance to trigger on-hit effects. (Cost: 25 Energy, Cooldown: 0 Turns)
* **[Lv 30] Venom-Laced Blade:** Your next attack applies a Poison DoT, dealing 20% of your AGI as damage per turn for 4 turns. (Cost: 35 Energy, Cooldown: 3 Turns)
* **[Lv 45] Smoke Bomb:** Instantly increases Evasion to 80% for 1 turn. (Cost: 50 Energy, Cooldown: 6 Turns)

### Weaver (Intelligence Focus — Resource: `Mana` 0–Max Mana)

* **[Lv 21] Arcane Bolt:** Deals 130% Magic Damage. Never misses. (Cost: 10 Mana, Cooldown: 0 Turns)
* **[Lv 30] Siphon Energy:** Deals 50% Magic Damage and restores Mana equal to the damage dealt. (Cost: 0 Mana, Generates Mana, Cooldown: 3 Turns)
* **[Lv 45] Void Shield:** Creates a barrier equal to 20% of your Max HP that absorbs incoming damage. (Cost: 30 Mana, Cooldown: 5 Turns)

### Warden (Summon/Utility Focus — Resource: `Animus` 0–100)

* **[Lv 21] Summon Void-Pup:** Summons a beast with 30% of your HP. It automatically attacks every turn for 50% of your INT. (Cost: 30 Animus, Cooldown: 8 Turns)
* **[Lv 30] Leeching Vines:** Entangles an enemy, dealing 80% Magic Damage and healing you for 50% of the damage dealt. (Cost: 25 Animus, Cooldown: 3 Turns)
* **[Lv 45] Shared Burden:** Transfers all your active debuffs (Poison, Chill) to your Summon. (Cost: 20 Animus, Cooldown: 4 Turns)

---

## 5. Phase 3: Second Job (Levels 51 - 70)

Advanced classes branch into pure offense, pure defense, or hybrid utility with enhanced resource mechanics.

### Berserker (from Juggernaut — Resource: `Bloodrage / Fury`)

* **[Lv 51] Reckless Swing:** Deals 200% Physical Damage, but you take 10% of your current HP in recoil damage. (Cost: 30 Fury + 10% Current HP, Cooldown: 2 Turns)
* **[Lv 60] Bloodlust (Buff):** For 3 turns, your Life Steal is increased by 20%, but your Armor drops to 0. (Cost: 50 Fury, Cooldown: 5 Turns)

### Void-Knight (from Juggernaut — Resource: `Resolve / Fury`)

* **[Lv 51] Shield Bash:** Deals Physical Damage equal to 100% of your Total Armor. Stuns non-boss enemies for 1 turn. (Cost: 25 Resolve/Fury, Cooldown: 3 Turns)
* **[Lv 60] Void Bulwark:** Absorbs all damage for 1 turn, storing it. Next turn, unleashes 50% of the stored damage as an AoE blast. (Cost: 40 Resolve/Fury, Cooldown: 6 Turns)

### Assassin (from Phantom — Resource: `Energy & Combo Points`)

* **[Lv 51] Eviscerate:** Deals massive damage based on the number of Poison/Bleed stacks currently on the enemy, then consumes the stacks. (Cost: 30 Energy, Cooldown: 2 Turns)
* **[Lv 60] Shadow Cloak:** Enter stealth for 2 turns. Enemies cannot target you (they will target your Companion or skip). Your next attack from stealth is a guaranteed Critical Hit. (Cost: 40 Energy, Cooldown: 5 Turns)

### Rift-Sniper (from Phantom — Resource: `Focus / Energy`)

* **[Lv 51] Aimed Shot:** Takes 1 turn to charge. On the 2nd turn, deals 350% Finesse Damage with 100% Armor Penetration. (Cost: 45 Focus/Energy, Cooldown: 4 Turns)
* **[Lv 60] Caltrops:** Throws spikes on the ground. Enemies take physical damage every time they execute a melee attack for 3 turns. (Cost: 30 Focus/Energy, Cooldown: 4 Turns)

### Elementalist (from Weaver — Resource: `Mana & Tri-Flux`)

* **[Lv 51] Elemental Cycle:** Cycles your active stance (Fire -> Ice -> Lightning). Fire grants +Damage, Ice grants +Armor, Lightning grants +Speed (allows 2 actions per turn). (Cost: 15 Mana, Cooldown: 1 Turn)
* **[Lv 60] Cataclysm:** Summons a meteor of your current active element, dealing 250% AoE Magic Damage. (Cost: 40 Mana, Cooldown: 5 Turns)

### Blood Mage (from Weaver — Resource: `Blood Essence / HP`)

* **[Lv 51] Hemorrhage:** Deals 150% Magic Damage. Costs 10% of your Max HP instead of Mana. (Cost: 10% Max HP, Cooldown: 1 Turn)
* **[Lv 60] Crimson Pact:** Kills your active Companion instantly to restore 100% of your HP and Mana. (Cost: Sacrifices Companion, Can only be used once per Node, Cooldown: 99 Turns)

### Necromancer (from Warden — Resource: `Animus & Corpses`)

* **[Lv 51] Raise Skeletal Mage:** Summons a ranged caster that deals Ice damage. You can have up to 3 skeletons active at once. (Cost: 25 Animus, Cooldown: 3 Turns)
* **[Lv 60] Corpse Explosion:** Detonates a dead enemy, dealing 100% of its Max HP as AoE damage to all remaining enemies. (Cost: 35 Animus, Cooldown: 2 Turns)

### Druid (from Warden — Resource: `Animus & Primal Surge`)

* **[Lv 51] Chimera Shift:** Transform into a Void-Beast for 4 turns. Replaces your spells with massive physical melee attacks that scale off both STR and INT. (Cost: 40 Animus, Cooldown: 6 Turns)
* **[Lv 60] Barkskin:** Increases your Total Armor by 100% and makes you immune to Critical Hits for 3 turns. (Cost: 30 Animus, Cooldown: 5 Turns)

---

## 6. Phase 4: Third Job / Pinnacle Classes (Level 70+)

Unlocked only after the "Breaking the Core" quest. These skills break standard game mechanics to handle the New Game+ difficulty.

### World-Breaker (from Berserker)

* **[Lv 70] Obliterate:** A catastrophic swing dealing 500% Physical Damage. If this kills the target, the cooldown instantly resets. (Cost: 60 Fury + 20% Current HP, Cooldown: 4 Turns)

### Aegis Lord (from Void-Knight)

* **[Lv 70] Absolute Defense:** For 2 turns, you are entirely immune to all forms of damage and instantly reflect any incoming attacks at 300% power. (Cost: 50 Resolve/Fury, Cooldown: 7 Turns)

### Shadow-Walker (from Assassin)

* **[Lv 70] Death Mark:** Marks a target. After 3 turns, the mark detonates, dealing true damage equal to 50% of the damage the target took during the countdown. (Cost: 50 Energy, Cooldown: 5 Turns)

### Void-Stalker (from Rift-Sniper)

* **[Lv 70] Dimensional Piercer:** Fires a shot that completely ignores the target's HP bar and directly attacks their Max HP stat, permanently reducing it by 20% for the remainder of the battle. (Cost: 60 Focus/Energy, Cooldown: 4 Turns)

### Arch-Mage (from Elementalist)

* **[Lv 70] Time Stop:** Freezes time. You take 3 consecutive turns back-to-back while the enemy and combat log are paused. (Cost: 60 Mana, Cooldown: 8 Turns)

### Crimson Sovereign (from Blood Mage)

* **[Lv 70] Blood Boil:** Converts your entire HP pool (leaving you at 1 HP) into raw Magic Damage, unleashing an AoE blast that deals damage equal to 5x the HP sacrificed. (Cost: All HP down to 1, Cooldown: 8 Turns)

### Death-Caller (from Necromancer)

* **[Lv 70] Army of the Damned:** Instantly summons 5 max-level elite skeletons that bypass the summon limit. They explode on death for massive Void damage. (Cost: 70 Animus, Cooldown: 8 Turns)

### Chimera-Lord (from Druid)

* **[Lv 70] Apex Evolution:** Passively merge all forms. You permanently gain the buffs of Chimera Shift without needing to transform, and every attack heals you and your companions for 10% of the damage dealt. (Passive: Always Active, Cooldown: 0 Turns)
