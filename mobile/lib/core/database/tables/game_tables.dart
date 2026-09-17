import 'package:drift/drift.dart';

@DataClassName('PlayerData')
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get jobClass => text().withDefault(const Constant('Vagabond'))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get currentExp => integer().withDefault(const Constant(0))();
  IntColumn get maxExp => integer().withDefault(const Constant(100))();
  IntColumn get baseHp => integer().withDefault(const Constant(50))();
  IntColumn get currentHp => integer().withDefault(const Constant(50))();
  IntColumn get strength => integer().withDefault(const Constant(10))();
  IntColumn get agility => integer().withDefault(const Constant(10))();
  IntColumn get intelligence => integer().withDefault(const Constant(10))();
  IntColumn get stamina => integer().withDefault(const Constant(10))();
  IntColumn get currentRoomId => integer().withDefault(const Constant(101))();
  IntColumn get silverPrisms => integer().withDefault(const Constant(0))();
}

@DataClassName('RoomData')
class Rooms extends Table {
  IntColumn get id => integer()();
  IntColumn get act => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get imageAssetPath => text().nullable()();
  
  // Cardinal exits (room IDs or null)
  IntColumn get northExitId => integer().nullable()();
  IntColumn get southExitId => integer().nullable()();
  IntColumn get eastExitId => integer().nullable()();
  IntColumn get westExitId => integer().nullable()();

  // Flags
  BoolColumn get isExplored => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ItemData')
class Items extends Table {
  TextColumn get id => text()(); // UUID
  IntColumn get ownerId => integer().nullable()(); // null = on ground in currentRoomId
  IntColumn get groundRoomId => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get baseType => text()(); // 'Weapon', 'Armor', 'Helm', 'Boots', 'Gem', 'Potion'
  TextColumn get rarity => text().withDefault(const Constant('Normal'))(); // Normal, Magic, Rare, Legendary, Set
  BoolColumn get isEquipped => boolean().withDefault(const Constant(false))();
  TextColumn get equipSlot => text().nullable()(); // 'Head', 'Chest', 'Waist', 'Arms', 'Feet', 'Neck', 'RingL', 'RingR', 'MainHand', 'OffHand'
  
  IntColumn get minDamage => integer().withDefault(const Constant(0))();
  IntColumn get maxDamage => integer().withDefault(const Constant(0))();
  IntColumn get armorValue => integer().withDefault(const Constant(0))();
  IntColumn get socketCount => integer().withDefault(const Constant(0))();
  
  // JSON array of dynamic affixes e.g. [{"type": "fire_damage", "val": 5}]
  TextColumn get modifiersJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MobData')
class Mobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get roomId => integer()();
  TextColumn get name => text()();
  IntColumn get level => integer()();
  IntColumn get maxHp => integer()();
  IntColumn get currentHp => integer()();
  IntColumn get minDamage => integer()();
  IntColumn get maxDamage => integer()();
  IntColumn get armor => integer().withDefault(const Constant(0))();
  IntColumn get expReward => integer()();
  BoolColumn get isAlive => boolean().withDefault(const Constant(true))();
  TextColumn get dropTableJson => text().withDefault(const Constant('[]'))();
}
