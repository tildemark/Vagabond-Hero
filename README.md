# Vagabond Hero

An offline-first, dark fantasy isekai text-based RPG mobile game built with **Flutter**, **Drift (SQLite)**, and **Riverpod**.

---

## 📖 Overview

You were staring at a terminal, compiling a legacy MUD script, when the screen shattered into blinding white light. You awaken not in your room, but in a petrified forest coated in grey ash within the **Shattered Expanse**—a fractured digital/magical realm governed by Nodes, Acts, and ancient system prompts.

*Vagabond Hero* blends classic text-heavy MUD dungeon crawling with modern ARPG mechanics: grid exploration, turn-based tactical combat, branching job classes, and Diablo-style procedural loot.

---

## 🎮 Key Features

- **Offline-First & Deterministic:** Powered by an offline SQLite database via Drift. No mandatory server connection required.
- **Node & Grid Navigation:** 5 Acts, each with 5–6 major Nodes containing 20–50 interconnected rooms with cardinal (NSEW) traversal and random encounters.
- **Turn-Based Combat:** Tactical turn-order mechanics, damage calculations, condition effects, and scrolling combat logs.
- **Diablo-Style Loot & Gem Sockets:** Procedural drops across 5 rarity tiers (*Normal*, *Magic*, *Rare*, *Legendary*, *Set*) with randomized affixes and socketable gems (Chipped to Perfect).
- **Branching Class Evolutions:**
  - **Lv 1:** Vagabond (Novice)
  - **Lv 20 Base Classes:** Juggernaut, Phantom, Weaver, Warden
  - **Lv 50 Ascensions:** Berserker, Void-Knight, Assassin, Rift-Sniper, Elementalist, Blood Mage, Necromancer, Druid
- **Endgame Echo System (Lv 70+):** Post-cap progression allocating Echo Points into infinite micro-stat bonuses.
- **Companions & Pets:** Equip mercenaries for combat support and pets for utility, auto-looting, and passive stat bonuses.
- **Minimalist Dark Aesthetic:** Clean, immersive terminal/console vibe with rich lore presentation, monospace/serif typography, and pre-rendered location backgrounds.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod` with Notifier/AsyncNotifier patterns)
- **Database & Persistence:** [Drift](https://drift.simonbinder.eu/) (type-safe SQLite abstraction)
- **Data Models & Serialization:** `freezed`, `json_serializable`
- **Assets & Rendering:** `flutter_svg` for procedural icons, WebP for environmental art

### System Architecture

The game adheres to a strict **Feature-Driven Clean Architecture**:

```text
lib/
├── core/                     # Cross-cutting configurations
│   ├── database/             # Drift database setup, DAOs, table schemas
│   ├── theme/                # Minimalist dark theme, typography, color tokens
│   └── utils/                # Dice rollers, RNG, math helpers
├── features/                 # Modular game domains
│   ├── navigation/           # Room traversal, node grids, exit validation
│   ├── combat/               # CombatEngine, turn manager, battle log
│   ├── inventory/            # Items, equipment slots, gem sockets, loot generation
│   └── character/            # Player stats, classes/jobs, leveling curves
└── main.dart                 # App entry point & ProviderScope
```

---

## 📚 Documentation

Detailed game design and technical documents are located in [`docs/`](file:///d:/code/Vagabond-Hero/docs):

- [Architecture Guide](file:///d:/code/Vagabond-Hero/docs/architecture.md) — Technical layers, database schemas, and state flow.
- [Game Mechanics](file:///d:/code/Vagabond-Hero/docs/mechanics.md) — Navigation grids, leveling, classes, loot formulas, and combat rules.
- [AI Agent Specifications](file:///d:/code/Vagabond-Hero/docs/agents.md) — Technical roles, design patterns, and code generation guidelines.
- **Story Acts:**
  - [Act I: The Ashen Awakening](file:///d:/code/Vagabond-Hero/docs/story/act1.md)
  - [Act II: The Sunken Core](file:///d:/code/Vagabond-Hero/docs/story/act2.md)
  - [Act III: Spire of the Glitched Sky](file:///d:/code/Vagabond-Hero/docs/story/act3.md)
  - [Act IV: The Void Foundry](file:///d:/code/Vagabond-Hero/docs/story/act4.md)
  - [Act V: The Terminal of Creation](file:///d:/code/Vagabond-Hero/docs/story/act5.md)

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x recommended)
- Dart SDK (included with Flutter)

### Setup & Installation

```bash
# Clone the repository
git clone https://github.com/tildemark/Vagabond-Hero.git
cd Vagabond-Hero

# Fetch dependencies (once project packages are set up)
flutter pub get

# Generate Drift and Freezed code
dart run build_runner build --delete-conflicting-outputs

# Launch on device or emulator
flutter run
```

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.
