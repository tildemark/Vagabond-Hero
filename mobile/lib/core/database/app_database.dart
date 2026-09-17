import 'package:drift/drift.dart';

import 'connection/unsupported.dart'
    if (dart.library.ffi) 'connection/native.dart'
    if (dart.library.js_interop) 'connection/web.dart' as impl;

import 'tables/game_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Players, Rooms, Items, Mobs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Seed default player
          await into(players).insert(
            PlayersCompanion.insert(
              name: 'Vagabond',
              jobClass: const Value('Vagabond'),
              level: const Value(1),
              currentExp: const Value(0),
              maxExp: const Value(100),
              baseHp: const Value(50),
              currentHp: const Value(50),
              strength: const Value(12),
              agility: const Value(10),
              intelligence: const Value(10),
              currentRoomId: const Value(101),
              silverPrisms: const Value(25),
            ),
          );

          // Seed Act I Rooms (Node 101, 102, 103, 104)
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(101),
              act: 1,
              title: 'Petrified Clearing',
              description:
                  'You awaken on a bed of cold, petrified leaves. Overhead, branches coated in grey ash block out the fractured sky. A hum emanates from an ancient CRT terminal embedded in cracked stone to the north.',
              northExitId: const Value(102),
              eastExitId: const Value(103),
              isExplored: const Value(true),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(102),
              act: 1,
              title: 'Ancient Monolith Terminal',
              description:
                  'A moss-covered terminal monolith towers over the broken cobblestone path. Green phosphor glow flickers against the obsidian stone face. An access port awaits input.',
              southExitId: const Value(101),
              eastExitId: const Value(104),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(103),
              act: 1,
              title: 'Ash Trail',
              description:
                  'A barren gravel track winds between petrified trees. The air smells of ozone and charred silicon. In the shadows, a glitched shape twitches with jagged digital artifacts.',
              westExitId: const Value(101),
              northExitId: const Value(104),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(104),
              act: 1,
              title: 'Crumbling Overlook',
              description:
                  'A sheer cliff edge overlooks the infinite abyss of the Shattered Expanse. Floating landmasses drift across the purple horizon like shattered continents suspended in static.',
              southExitId: const Value(103),
              westExitId: const Value(102),
              isExplored: const Value(false),
            ),
          );

          // Seed initial enemy in Room 103
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 103,
              name: 'Glitched Husk',
              level: 1,
              maxHp: 24,
              currentHp: 24,
              minDamage: 4,
              maxDamage: 7,
              armor: const Value(1),
              expReward: 35,
              dropTableJson: const Value(
                '[{"type":"gem","name":"Chipped Emerald","rate":0.5},{"type":"weapon","name":"Rusted Shiv","rate":0.8}]',
              ),
            ),
          );

          // Seed starter item in inventory
          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_dagger_01',
              name: 'Worn Shiv',
              baseType: 'Weapon',
              rarity: const Value('Normal'),
              isEquipped: const Value(true),
              equipSlot: const Value('MainHand'),
              minDamage: const Value(3),
              maxDamage: const Value(6),
              ownerId: const Value(1),
            ),
          );
        },
      );
}
