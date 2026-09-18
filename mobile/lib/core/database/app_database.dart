import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/game_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Players, Rooms, Items, Mobs])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

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
              stamina: const Value(10),
              currentRoomId: const Value(101),
              silverPrisms: const Value(25),
            ),
          );

          // ──────────────────────────────────────────────────────────────────────────
          // Seed Act I Rooms (Non-linear branching graph across Nodes 1-6 + Gateway)
          // ──────────────────────────────────────────────────────────────────────────

          // ── Node 1: The Shattered Clearing & Smuggler's Crevasse
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(101),
              act: 1,
              title: 'The Ashen Bed',
              description:
                  'You awaken on a bed of cold, petrified leaves. Overhead, branches coated in grey ash block out the fractured sky. A glowing system prompt flickers in your peripheral vision.',
              northExitId: const Value(102),
              eastExitId: const Value(103),
              isExplored: const Value(true),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(102),
              act: 1,
              title: 'The Petrified Path',
              description:
                  'The dirt is turned to grey glass. Near the base of an obsidian tree lies a fallen soldier in glitching armor, clutching a worn blade. The air hums with distant static.',
              southExitId: const Value(101),
              eastExitId: const Value(104),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(103),
              act: 1,
              title: 'The Hollowed Trunk',
              description:
                  'A barren gravel track winds through the decayed core of a colossal petrified sequoia. Corrupted vermin skitter in the phosphor shadows.',
              westExitId: const Value(101),
              northExitId: const Value(104),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(104),
              act: 1,
              title: 'The Void-Torn Edge',
              description:
                  'The forest shears off into an infinite abyss of purple clouds. To the north, a rickety bridge descends into the dark ravine (Whispering Hollow). To the east, a narrow crack leads into the Smuggler\'s Crevasse.',
              westExitId: const Value(102),
              southExitId: const Value(103),
              northExitId: const Value(201), // Path to Node 2 (Dungeon)
              eastExitId: const Value(105),  // Alternate bypass route
              isExplored: const Value(false),
            ),
          );

          // ── Alternate Branch A: Smuggler's Crevasse (Bypasses Spider Dungeon)
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(105),
              act: 1,
              title: 'Smuggler\'s Crevasse',
              description:
                  'A jagged fissure cutting through basalt cliffs. Wind howls through the narrow walls. Luminescent fungi pulse with warning signals: an apex stalker prowls here.',
              westExitId: const Value(104),
              eastExitId: const Value(106),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(106),
              act: 1,
              title: 'Abandoned Supply Depot',
              description:
                  'An old scavenger outpost carved into the rock. Crates stamped with ancient alphanumeric codes lie shattered. A rusted ladder leads directly up to the gates of Vanguard\'s Hold.',
              westExitId: const Value(105),
              northExitId: const Value(301), // Direct bypass connection to Node 3!
              isExplored: const Value(false),
            ),
          );

          // ── Node 2: The Whispering Hollow (Spider Dungeon)
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(201),
              act: 1,
              title: 'The Cave Mouth',
              description:
                  'You descend into a subterranean ravine. Bioluminescent spider silk pulses like glowing fiber-optic cabling across the damp stone walls.',
              southExitId: const Value(104),
              northExitId: const Value(202),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(202),
              act: 1,
              title: 'The Webbed Path',
              description:
                  'Thick webs of shimmering data-strands cross the path. Skeletal silhouettes twitched inside silk cocoons. Corrupted Weaver Spiders drop from the stalactites.',
              southExitId: const Value(201),
              northExitId: const Value(204),
              eastExitId: const Value(203), // Side chamber
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(203),
              act: 1,
              title: 'The Silk Cocoons',
              description:
                  'A secluded side alcove filled with crystallized web clusters. Broken weapons and forgotten traveler backpacks are buried under the sticky strands.',
              westExitId: const Value(202),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(204),
              act: 1,
              title: 'The Broodmother\'s Nest',
              description:
                  'A massive domed cavern. Hanging in the center is a bloated arachnid monstrosity glowing with volatile void sacks. Behind her nest, an opening leads upward toward firelight.',
              southExitId: const Value(202),
              northExitId: const Value(301), // Exits into Node 3
              isExplored: const Value(false),
            ),
          );

          // ── Node 3: The Vanguard\'s Hold (Safe Hub)
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(301),
              act: 1,
              title: 'The Iron Gates',
              description:
                  'A reinforced barricade of scrap iron and petrified timber. Watchmen in mismatched armor keep vigilant watch over the fog-choked approaches.',
              southExitId: const Value(204),
              westExitId: const Value(106), // Connection to Smuggler\'s Depot
              northExitId: const Value(302),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(302),
              act: 1,
              title: 'The Courtyard & Ward',
              description:
                  'A grim sanctuary. In the town square, the "Ward"—a colossal kite shield wired to an ancient arcane core—emits a continuous field of golden light that repels the void fog.',
              southExitId: const Value(301),
              westExitId: const Value(303), // Forge
              eastExitId: const Value(304), // Tavern
              northExitId: const Value(401), // Path to Sunken Chapel
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(303),
              act: 1,
              title: 'Garrick\'s Forge',
              description:
                  'Sparks shower the dirt floor. Garrick the Smith hammers away on void-tempered steel with a cybernetic arm. Anvil clangs echo with rhythmic determination.',
              eastExitId: const Value(302),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(304),
              act: 1,
              title: 'The Broker\'s Pavilion',
              description:
                  'A smoke-filled tent serving warm ale and dried rations. Elara the Broker reviews bounties and trade ledgers, her eyes darting to your wandering gear.',
              westExitId: const Value(302),
              isExplored: const Value(false),
            ),
          );

          // ── Node 4: The Sunken Chapel & Catacombs
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(401),
              act: 1,
              title: 'The Muddy Steps',
              description:
                  'Gothic stone steps descend into a swamp of black liquid Void. The sunken ruins of an antebellum cathedral sink into the bubbling mire.',
              southExitId: const Value(302),
              northExitId: const Value(402),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(402),
              act: 1,
              title: 'The Flooded Nave',
              description:
                  'Water sloshes between broken oak pews. Figures in drenched vestments murmur corrupted scripture, their faces obscured by floating holographic symbols.',
              southExitId: const Value(401),
              northExitId: const Value(404),
              eastExitId: const Value(403), // Vestry
              westExitId: const Value(405), // Alternate Branch: Catacombs!
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(403),
              act: 1,
              title: 'The Flooded Vestry',
              description:
                  'A partially submerged library containing liturgical manuscripts. When examined, the Latin script shifts intermittently into x86 assembler code.',
              westExitId: const Value(402),
              isExplored: const Value(false),
            ),
          );

          // ── Alternate Branch B: The Weeping Catacombs
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(405),
              act: 1,
              title: 'Sunken Crypt Vault',
              description:
                  'Cold black water drips from vaulted stone ceilings. An ancient defense automaton—a Corrupted Iron Golem—stands motionless before an iron sarcophagus.',
              eastExitId: const Value(402),
              northExitId: const Value(406),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(406),
              act: 1,
              title: 'Tomb of the First Scripter',
              description:
                  'A secluded burial chamber lined with crystal capacitors. An ornate chest rests upon a pediment of fossilized circuitry. A secret tunnel leads upward.',
              southExitId: const Value(405),
              eastExitId: const Value(404), // Secret flanking door to Boss Altar!
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(404),
              act: 1,
              title: 'The Ruined Altar',
              description:
                  'Before the shattered stained-glass rose window stands the Weeping Zealot, swinging an iron censor that billows cyan digital smoke.',
              southExitId: const Value(402),
              westExitId: const Value(406), // Secret door from Catacombs
              northExitId: const Value(501), // Path to Node 5
              isExplored: const Value(false),
            ),
          );

          // ── Node 5: The Charred Canopy & Glass Aerie
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(501),
              act: 1,
              title: 'Roots of the Behemoth',
              description:
                  'A petrified tree as wide as a fortress rises into the clouds. Spiraling grooves carved into the petrified bark form a perilous winding ramp.',
              southExitId: const Value(404),
              northExitId: const Value(502),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(502),
              act: 1,
              title: 'The Canopy Bridges',
              description:
                  'Rope bridges span between massive stone branches thousands of feet in the air. Glass-Wing Harpies circle overhead, their screeching distorting the soundscape.',
              southExitId: const Value(501),
              northExitId: const Value(503),
              eastExitId: const Value(504), // Alternate branch: Glass Aerie
              isExplored: const Value(false),
            ),
          );

          // ── Alternate Branch C: Glass Aerie Cliff Shortcut
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(504),
              act: 1,
              title: 'The Glass Aerie',
              description:
                  'A razor-sharp ridge jutting out above the clouds. Abandoned harpy nests glitter with fallen trinkets. A steep slide allows adventurous explorers to rappel straight to the Crater edge!',
              westExitId: const Value(502),
              northExitId: const Value(601), // Shortcut down to Node 6!
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(503),
              act: 1,
              title: 'Talon-Lord\'s Perch',
              description:
                  'The storm-battered summit of the giant canopy. Talon-Lord Vex perches on an ancient satellite dish antenna, feathers shimmering with razor static.',
              southExitId: const Value(502),
              northExitId: const Value(601), // Primary path down to Node 6
              isExplored: const Value(false),
            ),
          );

          // ── Node 6: The Ashen Crater (Act 1 Climax)
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(601),
              act: 1,
              title: 'The Crater Edge',
              description:
                  'You stand at the lip of a titanic impact crater. Below, a jagged fissure in reality pulses with raw purple light, warping gravity and text alike.',
              southExitId: const Value(503),
              eastExitId: const Value(504), // Reciprocal shortcut from Aerie
              northExitId: const Value(602),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(602),
              act: 1,
              title: 'Ground Zero',
              description:
                  'Floating slabs of shattered granite hover around a swirling gravity well. Reality feels dangerously brittle here—each step sends static ripples across the ground.',
              southExitId: const Value(601),
              northExitId: const Value(603),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(603),
              act: 1,
              title: 'The Glitching Heart',
              description:
                  'The center of the world rupture. The Hollow Woodsman stands guard, an Echo of a forgotten age trapped in heavy rust-eaten plate, his colossal battleaxe trailing pixel shards.',
              southExitId: const Value(602),
              northExitId: const Value(604),
              isExplored: const Value(false),
            ),
          );

          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(604),
              act: 1,
              title: 'Gateway to the Sunken City',
              description:
                  'A stabilized rift doorway hums with serene sapphire light. Beyond the event horizon lies the drowned metropolis of Act II: The Sunken City. Teleportation protocols active.',
              southExitId: const Value(603),
              northExitId: const Value(2101), // Gateway into Act 2
              isExplored: const Value(false),
            ),
          );

          // ── Act II Initial Room (Arrival Plate)
          await into(rooms).insert(
            RoomsCompanion.insert(
              id: const Value(2101),
              act: 2,
              title: 'The Arrival Plate',
              description:
                  'You emerge onto a fractured stone plaza submerged in knee-deep glowing blue liquid. Above, waves of heavy grey fog roll across an inverted subterranean ocean. Act II has begun.',
              southExitId: const Value(604),
              isExplored: const Value(false),
            ),
          );

          // ──────────────────────────────────────────────────────────────────────────
          // Seed Mobs, Rare Mini-Bosses & Act 1 Bosses
          // ──────────────────────────────────────────────────────────────────────────

          // Room 103: Common enemy
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 103,
              name: 'Void-Touched Rat',
              level: 1,
              maxHp: 20,
              currentHp: 20,
              minDamage: 3,
              maxDamage: 6,
              armor: const Value(1),
              expReward: 30,
              dropTableJson: const Value(
                '[{"type":"gem","name":"Chipped Emerald","rate":0.5},{"type":"weapon","name":"Rusted Shiv","rate":0.8}]',
              ),
            ),
          );

          // Room 105 (Branch A): Rare Mini-Boss - Void-Stalker Alpha (Can be bypassed or fled!)
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 105,
              name: 'Void-Stalker Alpha',
              level: 3,
              maxHp: 55,
              currentHp: 55,
              minDamage: 6,
              maxDamage: 11,
              armor: const Value(3),
              expReward: 120,
              isMiniBoss: const Value(true),
              dropTableJson: const Value(
                '[{"type":"ring","name":"Silver Coil Band","rate":0.9}]',
              ),
            ),
          );

          // Room 202: Weaver Spider
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 202,
              name: 'Weaver Spider',
              level: 2,
              maxHp: 32,
              currentHp: 32,
              minDamage: 5,
              maxDamage: 8,
              armor: const Value(2),
              expReward: 50,
            ),
          );

          // Room 204: Mini-Boss - The Broodmother
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 204,
              name: 'The Broodmother',
              level: 3,
              maxHp: 75,
              currentHp: 75,
              minDamage: 7,
              maxDamage: 13,
              armor: const Value(4),
              expReward: 180,
              isMiniBoss: const Value(true),
              dropTableJson: const Value(
                '[{"type":"ring","name":"Silk-Spun Ring","rate":1.0}]',
              ),
            ),
          );

          // Room 402: Risen Cultist
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 402,
              name: 'Risen Cultist',
              level: 4,
              maxHp: 44,
              currentHp: 44,
              minDamage: 7,
              maxDamage: 12,
              armor: const Value(2),
              expReward: 80,
            ),
          );

          // Room 405 (Branch B): Rare Mini-Boss - Corrupted Iron Golem (Can be fled/bypassed!)
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 405,
              name: 'Corrupted Iron Golem',
              level: 5,
              maxHp: 110,
              currentHp: 110,
              minDamage: 9,
              maxDamage: 16,
              armor: const Value(8),
              expReward: 240,
              isMiniBoss: const Value(true),
            ),
          );

          // Room 404: Mini-Boss - The Weeping Zealot
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 404,
              name: 'The Weeping Zealot',
              level: 5,
              maxHp: 95,
              currentHp: 95,
              minDamage: 8,
              maxDamage: 15,
              armor: const Value(4),
              expReward: 220,
              isMiniBoss: const Value(true),
            ),
          );

          // Room 502: Glass-Wing Harpy
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 502,
              name: 'Glass-Wing Harpy',
              level: 6,
              maxHp: 60,
              currentHp: 60,
              minDamage: 10,
              maxDamage: 17,
              armor: const Value(3),
              expReward: 110,
            ),
          );

          // Room 503: Mini-Boss - Talon-Lord Vex
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 503,
              name: 'Talon-Lord Vex',
              level: 7,
              maxHp: 125,
              currentHp: 125,
              minDamage: 11,
              maxDamage: 19,
              armor: const Value(5),
              expReward: 290,
              isMiniBoss: const Value(true),
            ),
          );

          // Room 603: Act 1 Climax Boss - The Hollow Woodsman
          await into(mobs).insert(
            MobsCompanion.insert(
              roomId: 603,
              name: 'The Hollow Woodsman',
              level: 8,
              maxHp: 180,
              currentHp: 180,
              minDamage: 14,
              maxDamage: 24,
              armor: const Value(7),
              expReward: 500,
              isMiniBoss: const Value(true),
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
              modifiersJson: const Value('{"description":"Coarse linen reinforced with cured beast hide stitches.","baseStats":{"STA":4,"STR":1}}'),
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
              modifiersJson: const Value('{"description":"Heavy leather wrapped around iron splints.","baseStats":{"STR":2,"STA":2}}'),
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
              modifiersJson: const Value('{"description":"A flexible girdle adorned with utility pouches.","baseStats":{"STA":3}}'),
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
              modifiersJson: const Value('{"description":"The heirloom ring of a forgotten crypt-keeper.","baseStats":{"STR":3,"STA":3},"buffs":["+12% Critical Hit Damage"],"otherModifiers":["+4% Life-Steal on Hit"]}'),
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
              modifiersJson: const Value('{"description":"Tough hide boots designed to weather sharp obsidian terrain.","baseStats":{"STA":2}}'),
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
                '"baseStats":{"STA":6,"STR":6},'
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

          // ── Seed Gems (Dedicated Gem Bag) ──────────────────────────────
          await into(items).insert(
            ItemsCompanion.insert(
              id: 'gem_ruby_01',
              name: 'Chipped Ruby',
              baseType: 'Gem',
              rarity: const Value('Normal'),
              isEquipped: const Value(false),
              modifiersJson: const Value(
                '{"description":"A rough crimson crystal pulsing with inner thermal embers.",'
                '"socketType":"Ruby (Fire / Physical)",'
                '"socketBonusWeapon":"+3 Fire Damage on Hit",'
                '"socketBonusArmor":"+15 Maximum Health",'
                '"buffs":["Socket in Weapon or Armor"]}'
              ),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'gem_sapphire_01',
              name: 'Flawed Sapphire',
              baseType: 'Gem',
              rarity: const Value('Magic'),
              isEquipped: const Value(false),
              modifiersJson: const Value(
                '{"description":"Cold azure stone extracted from the frozen subterranean springs.",'
                '"socketType":"Sapphire (Frost / Focus)",'
                '"socketBonusWeapon":"+5 Cold Damage, 10% Chance to Chill",'
                '"socketBonusArmor":"+20 Focus Pool & +5 Cold Resistance",'
                '"buffs":["Socket in Weapon or Armor"]}'
              ),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'gem_emerald_01',
              name: 'Chipped Emerald',
              baseType: 'Gem',
              rarity: const Value('Normal'),
              isEquipped: const Value(false),
              modifiersJson: const Value(
                '{"description":"A glistening green jewel that secretes a subtle venomous resin.",'
                '"socketType":"Emerald (Poison / Agility)",'
                '"socketBonusWeapon":"+8 Poison Damage over 3 seconds",'
                '"socketBonusArmor":"+4 Agility & +10 Poison Resistance",'
                '"buffs":["Socket in Weapon or Armor"]}'
              ),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'gem_amethyst_01',
              name: 'Regular Amethyst',
              baseType: 'Gem',
              rarity: const Value('Rare'),
              isEquipped: const Value(false),
              modifiersJson: const Value(
                '{"description":"A flawless violet gem radiating intense psychic static.",'
                '"socketType":"Amethyst (Void / Leech)",'
                '"socketBonusWeapon":"+4% Life-Steal on Hit",'
                '"socketBonusArmor":"+8 Stamina (+80 Max HP)",'
                '"buffs":["Socket in Weapon or Armor"]}'
              ),
              ownerId: const Value(1),
            ),
          );

          await into(items).insert(
            ItemsCompanion.insert(
              id: 'gem_diamond_01',
              name: 'Flawed Diamond',
              baseType: 'Gem',
              rarity: const Value('Magic'),
              isEquipped: const Value(false),
              modifiersJson: const Value(
                '{"description":"Unblemished prismatic diamond refracting ambient light into blinding shards.",'
                '"socketType":"Diamond (Radiance / All Resist)",'
                '"socketBonusWeapon":"+10% Critical Strike Multiplier",'
                '"socketBonusArmor":"+6 All Elemental Resistances & +3 Armor",'
                '"buffs":["Socket in Weapon or Armor"]}'
              ),
              ownerId: const Value(1),
            ),
          );
        },
      );
}

/// Opens (or creates) the SQLite database file in the app documents directory,
/// or uses IndexedDB / WebAssembly when running on the web.
QueryExecutor _openConnection() {
  if (kIsWeb) {
    return driftDatabase(
      name: 'vagabond_hero',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  return driftDatabase(
    name: 'vagabond_hero',
    native: DriftNativeOptions(
      databasePath: () async {
        final dir = await getApplicationDocumentsDirectory();
        return p.join(dir.path, 'vagabond_hero.sqlite');
      },
    ),
  );
}

