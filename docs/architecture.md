## Core Stack

* **Framework:** Flutter (Dart)
* **Local Database:** Drift (SQLite wrapper for type-safe relational data)
* **State Management:** Riverpod (`flutter_riverpod` for dependency injection and reactive UI)
* **Data Classes:** Freezed (for immutable states and pattern matching)
* **Assets:** `flutter_svg` for dynamic procedural graphics, local WebP for pre-rendered environment art.

## High-Level System Architecture

The application is strictly divided into three layers to isolate the game engine from the UI and database.

### 1. Data Layer (The World State)

This layer acts as the absolute source of truth. It contains the Drift database setup, the tables, and Data Access Objects (DAOs). The database holds both static world data (maps, bestiary) and dynamic save data (player inventory, current room).

* **Tables:** `Players`, `Rooms`, `Mobs`, `Items`, `EquippedGear`, `Inventory`.
* **DAOs:** Grouped SQL queries. For example, `InventoryDao` handles moving items between the ground, backpack, and equip slots.
* **Repositories:** Dart classes that wrap the DAOs and expose standard streams (`Stream<Player>`) to the Domain layer.

### 2. Domain Layer (The Game Engine)

This is the "Game Master." It contains pure Dart logic with no dependencies on Flutter UI components. It reads from the Data Layer, executes game rules, and writes back to the Data Layer.

* **Services:**
* `CombatEngine`: Calculates turn order, dice rolls, accuracy, and damage using standard RPG math.
* `LootGenerator`: Reads an enemy's loot table, rolls for item rarity (Normal to Legendary), generates random affixes, and inserts the new item into the database.
* `NavigationService`: Validates if a player can move to an adjacent room and updates the player's `currentRoomId`.


* **Calculators:** Pure functions like `StatCalculator` that take the base player stats, iterate over `EquippedGear`, sum up all modifiers and socketed gems, and output the final combat values.

### 3. Presentation Layer (The UI)

The UI is strictly reactive. It does not calculate damage or decide what loot drops. It simply listens to the Riverpod streams exposed by the Domain/Data layers and draws the screen. When a user presses "Attack," the UI sends an intent to the `CombatEngine` and waits for the database to update.

* **Providers (Riverpod):** `currentRoomProvider`, `combatLogProvider`, `playerHealthProvider`.
* **Widgets:** Stateless widgets that redraw instantly when their watched provider changes.

---

## Directory Structure Blueprint

Organize the Flutter `lib/` folder by feature rather than by layer. This makes scaling the complex RPG systems manageable.

```text
lib/
├── core/                     # App-wide configurations
│   ├── database/             # Drift database initialization and schema
│   │   ├── app_database.dart
│   │   └── tables/           # Drift table definitions (PlayerTable, RoomTable)
│   ├── theme/                # Dark minimalist styling, typography, colors
│   └── utils/                # Dice rollers, math helpers
├── features/                 # Game systems
│   ├── navigation/           # Room traversal and environment
│   │   ├── domain/           # Movement rules
│   │   └── presentation/     # Room description UI, WebP image loader, direction buttons
│   ├── combat/               # Battle mechanics
│   │   ├── domain/           # CombatEngine, TurnManager
│   │   └── presentation/     # Combat text log, enemy health bars, attack buttons
│   ├── inventory/            # Items, gear, and sockets
│   │   ├── data/             # Item DAO, Rarity enums
│   │   ├── domain/           # Equip logic, LootGenerator
│   │   └── presentation/     # Bag UI, equip slots, SVG gem icons
│   └── character/            # Player stats, jobs, leveling
│       ├── domain/           # EXP curves, Job change logic (Juggernaut, Weaver)
│       └── presentation/     # Stat sheet, level up modals
└── main.dart                 # Riverpod ProviderScope and app entry point

```

---

## Core Database Schema (Drift Entities)

The relationships in the Drift database govern the entire game loop.

### Player Table

Stores the singleton save state.

* `id` (Int, Primary Key)
* `name` (Text)
* `jobClass` (Text - e.g., 'Vagabond', 'Juggernaut')
* `level` (Int)
* `currentExp` (Int)
* `baseHp` (Int)
* `currentHp` (Int)
* `currentRoomId` (Int, Foreign Key -> Rooms)

### Rooms Table

The static map nodes.

* `id` (Int, Primary Key)
* `act` (Int)
* `title` (Text)
* `description` (Text)
* `imageAssetPath` (Text - e.g., 'assets/images/act1/clearing.webp')
* `northExitId`, `southExitId`, `eastExitId`, `westExitId` (Int, nullable)

### Items Table

Defines both template items and generated instances.

* `id` (Text, UUID, Primary Key)
* `ownerId` (Int, Foreign Key -> Players, nullable if on ground)
* `isEquipped` (Bool)
* `equipSlot` (Text - e.g., 'Weapon', 'Head', 'Chest')
* `baseType` (Text - e.g., 'Iron Shiv')
* `rarity` (Text - e.g., 'Normal', 'Rare', 'Legendary')
* `baseMinDamage`, `baseMaxDamage` (Int)
* `socketCount` (Int)
* `modifiersJson` (Text - stores dynamic affixes like `[{"+Fire Damage": 5}]`)

---

## The Reactive Data Flow (Example: Moving Rooms)

To understand how the architecture operates in practice, here is the lifecycle of a player tapping the "Move North" button:

1. **UI Action:** The user taps the `[Move North]` button in the `RoomView` widget.
2. **Intent Dispatch:** The widget calls `ref.read(navigationControllerProvider.notifier).move(Direction.north)`.
3. **Domain Validation:** The `NavigationService` checks the current room's `northExitId`. If it is `null`, it aborts. If it is valid (e.g., Room 102), it proceeds.
4. **Database Write:** The `PlayerDao` executes `UPDATE players SET currentRoomId = 102 WHERE id = 1`.
5. **Reactive Update:** Drift's active stream `watchPlayer()` detects the row change and pushes the new `Player` object to Riverpod.
6. **UI Redraw:** The `currentRoomProvider` updates. The UI instantly swaps the text description, updates the WebP background image, and generates a new set of directional buttons based on Room 102's exits.

## Asset Pipeline Strategy

* **Pre-rendered Environments (WebP):** Store compressed WebP files in `assets/images/environments/`. Reference these by file path directly in the `Rooms` database table. Load them using standard `Image.asset()`.
* **Procedural Event Graphics (SVG):** For items, gems, and combat effects, use `flutter_svg`. Store base SVG templates in `assets/svgs/`. Use Flutter's `String` manipulation or a custom SVG parser to dynamically change hex color codes within the SVG string based on item rarity (e.g., injecting `#FFD700` into the SVG for a Legendary item frame) before rendering it to the screen.