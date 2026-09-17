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

Detailed game design and technical documents are located in [`docs/`](docs):

- [Implementation Roadmap](docs/roadmap.md) — Phased delivery plan for `/landing`, `/web`, and `/mobile`.
- [Architecture Guide](docs/architecture.md) — Technical layers, database schemas, and state flow.
- [Game Mechanics](docs/mechanics.md) — Navigation grids, leveling, classes, loot formulas, and combat rules.
- [AI Agent Specifications](docs/agents.md) — Technical roles, design patterns, and code generation guidelines.
- **Story Acts:**
  - [Act I: The Ashen Awakening](docs/story/act1.md)
  - [Act II: The Sunken Core](docs/story/act2.md)
  - [Act III: Spire of the Glitched Sky](docs/story/act3.md)
  - [Act IV: The Void Foundry](docs/story/act4.md)
  - [Act V: The Terminal of Creation](docs/story/act5.md)

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x recommended)
- Dart SDK (included with Flutter)
- Python 3.x, Node.js (`npx serve`), or any static HTTP server (for the landing page)

### 🌐 Running the Landing Page Locally

The landing page (`/landing`) is built with vanilla HTML5, CSS3, and JavaScript, requiring zero build toolchains.

```bash
# Option 1: Using Python
python -m http.server 8085 --directory landing

# Option 2: Using Node.js npx
npx serve landing

# Option 3: Direct browser opening
# Open landing/index.html directly in any web browser
```

Visit `http://localhost:8085` in your browser.

When pushed to the `main` branch, the landing page and web game demo are automatically deployed to GitHub Pages via [.github/workflows/deploy-pages.yml](.github/workflows/deploy-pages.yml).

### 📱 Game Setup & Installation (Mobile & Web)

```bash
# Clone the repository
git clone https://github.com/tildemark/Vagabond-Hero.git
cd Vagabond-Hero/mobile

# Fetch dependencies
flutter pub get

# Generate Drift code
dart run build_runner build --delete-conflicting-outputs

# Launch on mobile device or emulator
flutter run

# Launch on web browser
flutter run -d chrome
```

---

## 🚀 CI/CD Pipelines

- **GitHub Pages Deployment ([.github/workflows/deploy-pages.yml](.github/workflows/deploy-pages.yml))**:
  - Compiles the Flutter Web release bundle.
  - Deploys the root landing page (`/`) and the live browser game demo (`/play/`) to GitHub Pages on every push to `main`.
- **Android Release APK ([.github/workflows/build-mobile-apk.yml](.github/workflows/build-mobile-apk.yml))**:
  - Runs Drift code generation, test suites, and compiles release `app-release.apk`.
  - Automatically attaches the APK to GitHub Releases on tag pushes (`v*`).

---

## 📜 Recent Updates

- **Phase 1 (Core Engine)**: Cross-platform Flutter engine with Drift SQLite relational persistence, Riverpod state management, Act I room traversal, and turn-based combat.
- **Phase 2 (Mobile App)**: Android branding, launcher icons, tactile haptic feedback on combat/navigation, and inventory bottom sheets.
- **Phase 3 (Web App)**: Desktop keyboard hotkeys (WASD, Space, 1, I), production CanvasKit/Wasm compilation, and browser save storage.
- **Phase 4 (Landing Page)**: Dark fantasy terminal landing page with interactive MUD simulation and direct APK download links.
- **Phase 5 (CI/CD Pipeline)**: GitHub Actions workflows for automated GitHub Pages hosting and Android APK release generation.

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.
