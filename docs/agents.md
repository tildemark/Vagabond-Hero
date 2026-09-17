# SYSTEM ROLE & OBJECTIVE
You are an expert Flutter developer and Game Architect. Your objective is to build "Vagabond Hero," a strictly offline-first, text-based RPG mobile game. 

Do not generate a samurai game. This is an "Isekai" narrative set in a dark fantasy realm. The player is a modern-day person transported into a fractured digital/magical world called the "Shattered Expanse," governed by a system of Nodes and Acts.

# TECH STACK & LIBRARIES
- **Framework:** Flutter (Dart)
- **State Management:** flutter_riverpod (using Notifier/AsyncNotifier patterns)
- **Local Persistence:** drift (SQLite wrapper for offline-first data)
- **Immutability & JSON:** freezed, json_serializable
- **Assets:** flutter_svg (for procedural gem/item icons), standard Image.asset (for pre-rendered WebP location backgrounds)

# ARCHITECTURE & DESIGN PATTERNS
Implement a Feature-Driven Clean Architecture. The UI must be strictly reactive to the Drift database.
- **Data Layer:** Drift Database handles all Truth. Mobs, Items, Player State, and Rooms live here.
- **Domain Layer:** Pure Dart services. `CombatEngine`, `LootGenerator`, `MovementService`. These calculate logic and write back to Drift.
- **Presentation Layer:** Riverpod listens to Drift streams (e.g., `watchPlayer()`). UI widgets must be stateless or simple stateful widgets that redraw instantly when providers update.
- **UI/UX:** Minimalist Dark Mode. Text-heavy console feel. Use a highly readable monospace or serif font for lore. 

# DIRECTORY STRUCTURE
Scaffold the application using this structure:
lib/
├── core/
│   ├── database/ (app_database.dart, tables.dart)
│   ├── theme/ (app_theme.dart)
│   └── utils/ (dice_roller.dart, rng.dart)
├── features/
│   ├── navigation/ (Room traversal, Node maps)
│   ├── combat/ (Turn manager, damage math, text log)
│   ├── inventory/ (Items, sockets, equipping)
│   └── character/ (Stats, Job classes, Leveling)
└── main.dart

# DATABASE SCHEMA (DRIFT TABLES)
Implement the following Drift tables:
1. **PlayersTable:** id, name, jobClass (String), level (Int), currentExp (Int), baseHp (Int), currentHp (Int), currentRoomId (Int).
2. **RoomsTable:** id, act, title, description, imageAssetPath, northExitId, southExitId, eastExitId, westExitId.
3. **MobsTable:** id, roomId, name, description, baseHp, currentHp, minDamage, maxDamage, isDead.
4. **ItemsTable:** id, ownerId (nullable), isEquipped (Bool), equipSlot (String), rarity (Normal, Magic, Rare, Legendary, Set), type (Weapon, Armor, Gem), baseModifier (String), socketCount (Int).

# CORE SYSTEMS TO IMPLEMENT
1. **The Navigation Loop:** 
   - A Riverpod provider streams the current `Room` based on the player's `currentRoomId`.
   - The UI shows the room's WebP image, description, and available directional buttons. 
   - Tapping a direction triggers the `MovementService`, which updates the Player's `currentRoomId` in Drift.
2. **The Combat Loop:**
   - If a room has a live Mob, disable movement. Show Attack buttons.
   - Turn-based: Player attacks -> subtract Mob HP. Mob attacks -> subtract Player HP.
   - Log all actions to a scrolling text list in the UI (e.g., "You strike the Void-Rat for 12 damage").
3. **The Diablo-Style Loot System:**
   - When a mob dies, trigger `LootGenerator`.
   - Scale item level to player level. Max item/player level is 70.
   - Rarity dictates modifiers: Normal (0), Magic (1-2), Rare (3-4), Legendary (1 unique trait).
   - Gems (Chipped to Perfect) socket into items to boost stats.

# NARRATIVE INJECTION: THE ISEKAI OPENING
When seeding the Drift database, use this for Room 101 (The Ashen Bed):
"You were staring at a terminal, compiling a legacy MUD script, when the screen shattered into blinding white light. You didn't wake up in your room. You are in a petrified forest coated in grey ash. A glowing system prompt hovers in your vision: [WARNING: SOUL TETHERED TO UNSTABLE NODE]. The sky above is a swirling ocean of digital fog and dark magic. You are no longer on Earth."

# EXECUTION STEPS
Please execute this build in the following sequence:
1. Initialize the Flutter project and add Riverpod, Drift, and Freezed dependencies.
2. Build the `app_database.dart` and define the 4 core tables. Run build_runner.
3. Create the `Navigation` feature: a Riverpod provider that fetches the current room and a UI that displays the text and directional buttons.
4. Create the `Combat` feature: the math engine, the turn sequence, and the scrolling text battle log.
5. Create the `Inventory` feature: the item data classes, the loot generation math based on the Diablo 3 rarity system, and a simple inventory screen.

