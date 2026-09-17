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

          // Seed starter items in inventory
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
              armorValue: const Value(0),
              socketCount: const Value(1),
              modifiersJson: const Value('{"description":"A nicked iron shiv favored by scavengers in the lower ruins."}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_chest_01',
              name: 'Drifter Tunic',
              baseType: 'Chest',
              rarity: const Value('Normal'),
              isEquipped: const Value(true),
              equipSlot: const Value('Chest'),
              armorValue: const Value(4),
              modifiersJson: const Value('{"description":"Coarse linen reinforced with cured beast hide stitches.","baseStats":{"VIT":3}}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_head_01',
              name: 'Ashbound Hood',
              baseType: 'Head',
              rarity: const Value('Magic'),
              isEquipped: const Value(false),
              equipSlot: const Value('Head'),
              armorValue: const Value(2),
              modifiersJson: const Value('{"description":"Woven from fire-retardant threads steeped in mountain ash.","baseStats":{"AGI":3},"buffs":["+5% Evasion Rate"]}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_neck_01',
              name: 'Opal Pendant',
              baseType: 'Neck',
              rarity: const Value('Magic'),
              isEquipped: const Value(false),
              equipSlot: const Value('Neck'),
              minDamage: const Value(1),
              maxDamage: const Value(2),
              armorValue: const Value(1),
              modifiersJson: const Value('{"description":"A cloudy gem humming with faint resonance from the deep rifts.","baseStats":{"INT":4},"buffs":["+8 Max Mana / Focus"]}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_arms_01',
              name: 'Reinforced Bracers',
              baseType: 'Arms',
              rarity: const Value('Normal'),
              isEquipped: const Value(false),
              equipSlot: const Value('Arms'),
              armorValue: const Value(2),
              modifiersJson: const Value('{"description":"Heavy leather wrapped around iron splints.","baseStats":{"STR":2}}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_waist_01',
              name: 'Riven Leather Sash',
              baseType: 'Waist',
              rarity: const Value('Normal'),
              isEquipped: const Value(false),
              equipSlot: const Value('Waist'),
              armorValue: const Value(2),
              modifiersJson: const Value('{"description":"A flexible girdle adorned with utility pouches.","baseStats":{"VIT":2}}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_ring_01',
              name: 'Silver Coil Band',
              baseType: 'Ring',
              rarity: const Value('Magic'),
              isEquipped: const Value(false),
              equipSlot: const Value('RingL'),
              minDamage: const Value(1),
              maxDamage: const Value(3),
              modifiersJson: const Value('{"description":"Polished silver carved with miniature wards.","statRolls":["+5% Critical Hit Chance"]}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_ring_02',
              name: 'Glinting Signet',
              baseType: 'Ring',
              rarity: const Value('Rare'),
              isEquipped: const Value(false),
              equipSlot: const Value('RingR'),
              armorValue: const Value(2),
              modifiersJson: const Value('{"description":"The heirloom ring of a forgotten crypt-keeper.","baseStats":{"STR":3,"VIT":4},"buffs":["+12% Critical Hit Damage"],"otherModifiers":["+4% Life-Steal on Hit"]}'),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'starter_feet_01',
              name: 'Dust Strider Boots',
              baseType: 'Feet',
              rarity: const Value('Normal'),
              isEquipped: const Value(false),
              equipSlot: const Value('Feet'),
              armorValue: const Value(3),
              modifiersJson: const Value('{"description":"Tough hide boots designed to weather sharp obsidian terrain."}'),
              ownerId: const Value(1),
            ),
          );

          // ── Showcase Items: Legendary, Set, and Glitched ────────────────
          await into(items).insert(
            ItemsCompanion.insert(
              id: 'showcase_legendary_01',
              name: 'Voidcaller Wand',
              baseType: 'Weapon',
              rarity: const Value('Legendary'),
              isEquipped: const Value(false),
              equipSlot: const Value('MainHand'),
              minDamage: const Value(14),
              maxDamage: const Value(28),
              socketCount: const Value(2),
              modifiersJson: const Value(
                '{"description":"Hewn from petrified abyssal driftwood. Echoes of silent screams linger on its tip.",'
                '"baseStats":{"INT":12,"STR":4},'
                '"buffs":["+18% Shadow Damage","+10% Cast Speed"],'
                '"uniqueTrait":"Echo of the Void: Attacks unleash a secondary dark shockwave dealing 40% weapon damage.",'
                '"otherModifiers":["+6% Life-Steal","+15 Shadow Resistance"]}'
              ),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'showcase_set_01',
              name: "Drowned King's Helm",
              baseType: 'Head',
              rarity: const Value('Set'),
              isEquipped: const Value(false),
              equipSlot: const Value('Head'),
              armorValue: const Value(12),
              socketCount: const Value(1),
              modifiersJson: const Value(
                '{"description":"Crown of the submerged sovereign, encrusted with barnacles that bleed cold brine.",'
                '"baseStats":{"VIT":8,"STR":6},'
                '"buffs":["+8% Maximum Health"],'
                '"set":{"name":"The Drowned King\'s Regalia","pieces":["Plate Armor","Helmet","Boots"],'
                '"bonuses":[{"count":2,"desc":"+25% Cold & Water Resistance"},{"count":3,"desc":"Attacks trigger a tidal surge dealing 60% weapon damage to all enemies."}]}}'
              ),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'showcase_glitched_01',
              name: 'Fragment of the Null',
              baseType: 'Weapon',
              rarity: const Value('Glitched'),
              isEquipped: const Value(false),
              equipSlot: const Value('OffHand'),
              minDamage: const Value(35),
              maxDamage: const Value(60),
              socketCount: const Value(3),
              modifiersJson: const Value(
                '{"description":"Anomalous digital artefact from Act 5. The reality around this crystal visibly stutters and tears.",'
                '"baseStats":{"STR":20,"AGI":15},'
                '"buffs":["+40% Critical Strike Chance","+80% Attack Speed"],'
                '"glitch":{"positive":"+300% Total Damage dealt across all weapons and skills.",'
                '"penalty":"Fatal Vulnerability: Maximum HP is permanently capped at 1 while equipped."}}'
              ),
              ownerId: const Value(1),
            ),
          );
        },
      );
}
