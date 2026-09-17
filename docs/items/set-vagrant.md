# Vagabond Hero: Vagrant Set Item Database

**File:** `item-sets-vagrant.md`
**System:** Equipment Database (Set Items)

---

## SET 1: The Scholar's Pilgrimage

**Focus:** EXP Generation & Rapid Leveling
*A 3-piece set worn by the first wanderers of the Shattered Expanse who sought to map the corrupted nodes. Highly prized by players grinding to reach their next Job Change.*

### Set Bonuses

* **[2-Piece Bonus]:** +25% EXP Gained from all sources.
* **[3-Piece Bonus - "Enlightened Grind"]:** Killing an enemy grants a stacking buff called *Momentum*. Each stack grants +5% EXP and +5% Movement/Attack Speed (Max 10 stacks). The buff resets if you return to a Safe Hub.

### The Items

| ID | Item Name | Slot | Req Lvl | Base Stat | Modifiers | Description |
| --- | --- | --- | --- | --- | --- | --- |
| S1-V01 | **Pilgrim's Cowl** | Head (Hood) | 15 | 22 Armor | +15 All Stats<br>

<br>+10% EXP Gained<br>

<br>+20 Max HP<br>

| A dusty hood that smells of old parchment and ozone. |
| S1-V02 | **Pilgrim's Tunic** | Torso (Shirt) | 15 | 35 Armor | +25 All Stats<br>

<br>+15% EXP Gained<br>

<br>+5% Evasion<br>

| Woven with protective runes that glow faintly in the dark. |
| S1-V03 | **Seeker's Loop** | Finger (Ring) | 15 | *None* | +10% EXP Gained<br>

<br>+10% Cooldown Reduc.<br>

<br>+5% All Resist<br>

| A simple wooden band that vibrates when near unexplored rooms. |

---

## SET 2: The Ash-Walker's Hoard

**Focus:** Scavenging, Gold Generation, & Magic Find
*A 4-piece set embodying the scrappy survivalism of the Vagrant. Synergizes perfectly with the Vagabond's innate "Scavenger" trait to farm currency and rare items efficiently.*

### Set Bonuses

* **[2-Piece Bonus]:** +50% Gold Drop Rate.
* **[3-Piece Bonus]:** +30% Magic Find.
* **[4-Piece Bonus - "One Man's Trash"]:** Defeating an enemy has a 15% chance to instantly drop a random Consumable or Gem. Additionally, picking up Gold heals you for 2% of your Max HP per coin looted.

### The Items

| ID | Item Name | Slot | Req Lvl | Base Stat | Modifiers | Description |
| --- | --- | --- | --- | --- | --- | --- |
| S2-V01 | **Scavenger's Hook** | L-Hand (1H) | 18 | 18 - 25 Dmg | +20 Agility<br>

<br>+15% Gold Drop Rate<br>

<br>+5% Attack Speed<br>

| A rusted grappling hook repurposed as a brutal melee weapon. |
| S2-V02 | **Trash-Lid Buckler** | R-Hand (Shield) | 18 | 20 Armor | +20 Stamina<br>

<br>+15% Magic Find<br>

<br>+5% Block Chance<br>

| Literally a dented trash can lid, painted with a crude smiley face. |
| S2-V03 | **Hoarder's Bandolier** | Waist (Belt) | 18 | 15 Armor | +15 All Stats<br>

<br>+20% Potion Effect<br>

<br>+15% Gold Drop Rate<br>

| Covered in clinking pouches overflowing with junk and coins. |
| S2-V04 | **Ash-Trotters** | Feet (Boots) | 18 | 25 Armor | +20 Agility<br>

<br>+10% Movement Speed<br>

<br>+15% Magic Find<br>

| Lightweight boots designed to outrun trouble with heavy pockets. |

---

## Code Implementation Logic (Set Bonuses)

When the `CombatEngine` initializes the player's stats at the start of a battle (or node exploration), it checks the `isEquipped` inventory list.

```dart
// Example Flutter/Dart logic for Set Evaluation
int pilgrimPieces = equippedItems.where((item) => item.setName == 'The Scholar\'s Pilgrimage').length;

if (pilgrimPieces >= 2) {
    playerStats.expMultiplier += 0.25; 
}
if (pilgrimPieces >= 3) {
    playerStats.activeTraits.add('Enlightened Grind'); 
}

int ashWalkerPieces = equippedItems.where((item) => item.setName == 'The Ash-Walker\'s Hoard').length;

if (ashWalkerPieces >= 2) {
    playerStats.goldDropMultiplier += 0.50;
}
if (ashWalkerPieces >= 3) {
    playerStats.magicFindMultiplier += 0.30;
}
if (ashWalkerPieces >= 4) {
    playerStats.activeTraits.add('One Man\'s Trash');
}
