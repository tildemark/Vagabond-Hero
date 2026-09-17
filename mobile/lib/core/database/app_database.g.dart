// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayersTable extends Players with TableInfo<$PlayersTable, PlayerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobClassMeta = const VerificationMeta(
    'jobClass',
  );
  @override
  late final GeneratedColumn<String> jobClass = GeneratedColumn<String>(
    'job_class',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Vagabond'),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentExpMeta = const VerificationMeta(
    'currentExp',
  );
  @override
  late final GeneratedColumn<int> currentExp = GeneratedColumn<int>(
    'current_exp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxExpMeta = const VerificationMeta('maxExp');
  @override
  late final GeneratedColumn<int> maxExp = GeneratedColumn<int>(
    'max_exp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _baseHpMeta = const VerificationMeta('baseHp');
  @override
  late final GeneratedColumn<int> baseHp = GeneratedColumn<int>(
    'base_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _currentHpMeta = const VerificationMeta(
    'currentHp',
  );
  @override
  late final GeneratedColumn<int> currentHp = GeneratedColumn<int>(
    'current_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<int> strength = GeneratedColumn<int>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _agilityMeta = const VerificationMeta(
    'agility',
  );
  @override
  late final GeneratedColumn<int> agility = GeneratedColumn<int>(
    'agility',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _intelligenceMeta = const VerificationMeta(
    'intelligence',
  );
  @override
  late final GeneratedColumn<int> intelligence = GeneratedColumn<int>(
    'intelligence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _currentRoomIdMeta = const VerificationMeta(
    'currentRoomId',
  );
  @override
  late final GeneratedColumn<int> currentRoomId = GeneratedColumn<int>(
    'current_room_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(101),
  );
  static const VerificationMeta _silverPrismsMeta = const VerificationMeta(
    'silverPrisms',
  );
  @override
  late final GeneratedColumn<int> silverPrisms = GeneratedColumn<int>(
    'silver_prisms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    jobClass,
    level,
    currentExp,
    maxExp,
    baseHp,
    currentHp,
    strength,
    agility,
    intelligence,
    currentRoomId,
    silverPrisms,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('job_class')) {
      context.handle(
        _jobClassMeta,
        jobClass.isAcceptableOrUnknown(data['job_class']!, _jobClassMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('current_exp')) {
      context.handle(
        _currentExpMeta,
        currentExp.isAcceptableOrUnknown(data['current_exp']!, _currentExpMeta),
      );
    }
    if (data.containsKey('max_exp')) {
      context.handle(
        _maxExpMeta,
        maxExp.isAcceptableOrUnknown(data['max_exp']!, _maxExpMeta),
      );
    }
    if (data.containsKey('base_hp')) {
      context.handle(
        _baseHpMeta,
        baseHp.isAcceptableOrUnknown(data['base_hp']!, _baseHpMeta),
      );
    }
    if (data.containsKey('current_hp')) {
      context.handle(
        _currentHpMeta,
        currentHp.isAcceptableOrUnknown(data['current_hp']!, _currentHpMeta),
      );
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('agility')) {
      context.handle(
        _agilityMeta,
        agility.isAcceptableOrUnknown(data['agility']!, _agilityMeta),
      );
    }
    if (data.containsKey('intelligence')) {
      context.handle(
        _intelligenceMeta,
        intelligence.isAcceptableOrUnknown(
          data['intelligence']!,
          _intelligenceMeta,
        ),
      );
    }
    if (data.containsKey('current_room_id')) {
      context.handle(
        _currentRoomIdMeta,
        currentRoomId.isAcceptableOrUnknown(
          data['current_room_id']!,
          _currentRoomIdMeta,
        ),
      );
    }
    if (data.containsKey('silver_prisms')) {
      context.handle(
        _silverPrismsMeta,
        silverPrisms.isAcceptableOrUnknown(
          data['silver_prisms']!,
          _silverPrismsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      jobClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_class'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      currentExp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_exp'],
      )!,
      maxExp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_exp'],
      )!,
      baseHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_hp'],
      )!,
      currentHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_hp'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strength'],
      )!,
      agility: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}agility'],
      )!,
      intelligence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intelligence'],
      )!,
      currentRoomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_room_id'],
      )!,
      silverPrisms: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}silver_prisms'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class PlayerData extends DataClass implements Insertable<PlayerData> {
  final int id;
  final String name;
  final String jobClass;
  final int level;
  final int currentExp;
  final int maxExp;
  final int baseHp;
  final int currentHp;
  final int strength;
  final int agility;
  final int intelligence;
  final int currentRoomId;
  final int silverPrisms;
  const PlayerData({
    required this.id,
    required this.name,
    required this.jobClass,
    required this.level,
    required this.currentExp,
    required this.maxExp,
    required this.baseHp,
    required this.currentHp,
    required this.strength,
    required this.agility,
    required this.intelligence,
    required this.currentRoomId,
    required this.silverPrisms,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['job_class'] = Variable<String>(jobClass);
    map['level'] = Variable<int>(level);
    map['current_exp'] = Variable<int>(currentExp);
    map['max_exp'] = Variable<int>(maxExp);
    map['base_hp'] = Variable<int>(baseHp);
    map['current_hp'] = Variable<int>(currentHp);
    map['strength'] = Variable<int>(strength);
    map['agility'] = Variable<int>(agility);
    map['intelligence'] = Variable<int>(intelligence);
    map['current_room_id'] = Variable<int>(currentRoomId);
    map['silver_prisms'] = Variable<int>(silverPrisms);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      name: Value(name),
      jobClass: Value(jobClass),
      level: Value(level),
      currentExp: Value(currentExp),
      maxExp: Value(maxExp),
      baseHp: Value(baseHp),
      currentHp: Value(currentHp),
      strength: Value(strength),
      agility: Value(agility),
      intelligence: Value(intelligence),
      currentRoomId: Value(currentRoomId),
      silverPrisms: Value(silverPrisms),
    );
  }

  factory PlayerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      jobClass: serializer.fromJson<String>(json['jobClass']),
      level: serializer.fromJson<int>(json['level']),
      currentExp: serializer.fromJson<int>(json['currentExp']),
      maxExp: serializer.fromJson<int>(json['maxExp']),
      baseHp: serializer.fromJson<int>(json['baseHp']),
      currentHp: serializer.fromJson<int>(json['currentHp']),
      strength: serializer.fromJson<int>(json['strength']),
      agility: serializer.fromJson<int>(json['agility']),
      intelligence: serializer.fromJson<int>(json['intelligence']),
      currentRoomId: serializer.fromJson<int>(json['currentRoomId']),
      silverPrisms: serializer.fromJson<int>(json['silverPrisms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'jobClass': serializer.toJson<String>(jobClass),
      'level': serializer.toJson<int>(level),
      'currentExp': serializer.toJson<int>(currentExp),
      'maxExp': serializer.toJson<int>(maxExp),
      'baseHp': serializer.toJson<int>(baseHp),
      'currentHp': serializer.toJson<int>(currentHp),
      'strength': serializer.toJson<int>(strength),
      'agility': serializer.toJson<int>(agility),
      'intelligence': serializer.toJson<int>(intelligence),
      'currentRoomId': serializer.toJson<int>(currentRoomId),
      'silverPrisms': serializer.toJson<int>(silverPrisms),
    };
  }

  PlayerData copyWith({
    int? id,
    String? name,
    String? jobClass,
    int? level,
    int? currentExp,
    int? maxExp,
    int? baseHp,
    int? currentHp,
    int? strength,
    int? agility,
    int? intelligence,
    int? currentRoomId,
    int? silverPrisms,
  }) => PlayerData(
    id: id ?? this.id,
    name: name ?? this.name,
    jobClass: jobClass ?? this.jobClass,
    level: level ?? this.level,
    currentExp: currentExp ?? this.currentExp,
    maxExp: maxExp ?? this.maxExp,
    baseHp: baseHp ?? this.baseHp,
    currentHp: currentHp ?? this.currentHp,
    strength: strength ?? this.strength,
    agility: agility ?? this.agility,
    intelligence: intelligence ?? this.intelligence,
    currentRoomId: currentRoomId ?? this.currentRoomId,
    silverPrisms: silverPrisms ?? this.silverPrisms,
  );
  PlayerData copyWithCompanion(PlayersCompanion data) {
    return PlayerData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      jobClass: data.jobClass.present ? data.jobClass.value : this.jobClass,
      level: data.level.present ? data.level.value : this.level,
      currentExp: data.currentExp.present
          ? data.currentExp.value
          : this.currentExp,
      maxExp: data.maxExp.present ? data.maxExp.value : this.maxExp,
      baseHp: data.baseHp.present ? data.baseHp.value : this.baseHp,
      currentHp: data.currentHp.present ? data.currentHp.value : this.currentHp,
      strength: data.strength.present ? data.strength.value : this.strength,
      agility: data.agility.present ? data.agility.value : this.agility,
      intelligence: data.intelligence.present
          ? data.intelligence.value
          : this.intelligence,
      currentRoomId: data.currentRoomId.present
          ? data.currentRoomId.value
          : this.currentRoomId,
      silverPrisms: data.silverPrisms.present
          ? data.silverPrisms.value
          : this.silverPrisms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('jobClass: $jobClass, ')
          ..write('level: $level, ')
          ..write('currentExp: $currentExp, ')
          ..write('maxExp: $maxExp, ')
          ..write('baseHp: $baseHp, ')
          ..write('currentHp: $currentHp, ')
          ..write('strength: $strength, ')
          ..write('agility: $agility, ')
          ..write('intelligence: $intelligence, ')
          ..write('currentRoomId: $currentRoomId, ')
          ..write('silverPrisms: $silverPrisms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    jobClass,
    level,
    currentExp,
    maxExp,
    baseHp,
    currentHp,
    strength,
    agility,
    intelligence,
    currentRoomId,
    silverPrisms,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerData &&
          other.id == this.id &&
          other.name == this.name &&
          other.jobClass == this.jobClass &&
          other.level == this.level &&
          other.currentExp == this.currentExp &&
          other.maxExp == this.maxExp &&
          other.baseHp == this.baseHp &&
          other.currentHp == this.currentHp &&
          other.strength == this.strength &&
          other.agility == this.agility &&
          other.intelligence == this.intelligence &&
          other.currentRoomId == this.currentRoomId &&
          other.silverPrisms == this.silverPrisms);
}

class PlayersCompanion extends UpdateCompanion<PlayerData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> jobClass;
  final Value<int> level;
  final Value<int> currentExp;
  final Value<int> maxExp;
  final Value<int> baseHp;
  final Value<int> currentHp;
  final Value<int> strength;
  final Value<int> agility;
  final Value<int> intelligence;
  final Value<int> currentRoomId;
  final Value<int> silverPrisms;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.jobClass = const Value.absent(),
    this.level = const Value.absent(),
    this.currentExp = const Value.absent(),
    this.maxExp = const Value.absent(),
    this.baseHp = const Value.absent(),
    this.currentHp = const Value.absent(),
    this.strength = const Value.absent(),
    this.agility = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.currentRoomId = const Value.absent(),
    this.silverPrisms = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.jobClass = const Value.absent(),
    this.level = const Value.absent(),
    this.currentExp = const Value.absent(),
    this.maxExp = const Value.absent(),
    this.baseHp = const Value.absent(),
    this.currentHp = const Value.absent(),
    this.strength = const Value.absent(),
    this.agility = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.currentRoomId = const Value.absent(),
    this.silverPrisms = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PlayerData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? jobClass,
    Expression<int>? level,
    Expression<int>? currentExp,
    Expression<int>? maxExp,
    Expression<int>? baseHp,
    Expression<int>? currentHp,
    Expression<int>? strength,
    Expression<int>? agility,
    Expression<int>? intelligence,
    Expression<int>? currentRoomId,
    Expression<int>? silverPrisms,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (jobClass != null) 'job_class': jobClass,
      if (level != null) 'level': level,
      if (currentExp != null) 'current_exp': currentExp,
      if (maxExp != null) 'max_exp': maxExp,
      if (baseHp != null) 'base_hp': baseHp,
      if (currentHp != null) 'current_hp': currentHp,
      if (strength != null) 'strength': strength,
      if (agility != null) 'agility': agility,
      if (intelligence != null) 'intelligence': intelligence,
      if (currentRoomId != null) 'current_room_id': currentRoomId,
      if (silverPrisms != null) 'silver_prisms': silverPrisms,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? jobClass,
    Value<int>? level,
    Value<int>? currentExp,
    Value<int>? maxExp,
    Value<int>? baseHp,
    Value<int>? currentHp,
    Value<int>? strength,
    Value<int>? agility,
    Value<int>? intelligence,
    Value<int>? currentRoomId,
    Value<int>? silverPrisms,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      jobClass: jobClass ?? this.jobClass,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      maxExp: maxExp ?? this.maxExp,
      baseHp: baseHp ?? this.baseHp,
      currentHp: currentHp ?? this.currentHp,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      intelligence: intelligence ?? this.intelligence,
      currentRoomId: currentRoomId ?? this.currentRoomId,
      silverPrisms: silverPrisms ?? this.silverPrisms,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (jobClass.present) {
      map['job_class'] = Variable<String>(jobClass.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (currentExp.present) {
      map['current_exp'] = Variable<int>(currentExp.value);
    }
    if (maxExp.present) {
      map['max_exp'] = Variable<int>(maxExp.value);
    }
    if (baseHp.present) {
      map['base_hp'] = Variable<int>(baseHp.value);
    }
    if (currentHp.present) {
      map['current_hp'] = Variable<int>(currentHp.value);
    }
    if (strength.present) {
      map['strength'] = Variable<int>(strength.value);
    }
    if (agility.present) {
      map['agility'] = Variable<int>(agility.value);
    }
    if (intelligence.present) {
      map['intelligence'] = Variable<int>(intelligence.value);
    }
    if (currentRoomId.present) {
      map['current_room_id'] = Variable<int>(currentRoomId.value);
    }
    if (silverPrisms.present) {
      map['silver_prisms'] = Variable<int>(silverPrisms.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('jobClass: $jobClass, ')
          ..write('level: $level, ')
          ..write('currentExp: $currentExp, ')
          ..write('maxExp: $maxExp, ')
          ..write('baseHp: $baseHp, ')
          ..write('currentHp: $currentHp, ')
          ..write('strength: $strength, ')
          ..write('agility: $agility, ')
          ..write('intelligence: $intelligence, ')
          ..write('currentRoomId: $currentRoomId, ')
          ..write('silverPrisms: $silverPrisms')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, RoomData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actMeta = const VerificationMeta('act');
  @override
  late final GeneratedColumn<int> act = GeneratedColumn<int>(
    'act',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageAssetPathMeta = const VerificationMeta(
    'imageAssetPath',
  );
  @override
  late final GeneratedColumn<String> imageAssetPath = GeneratedColumn<String>(
    'image_asset_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _northExitIdMeta = const VerificationMeta(
    'northExitId',
  );
  @override
  late final GeneratedColumn<int> northExitId = GeneratedColumn<int>(
    'north_exit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _southExitIdMeta = const VerificationMeta(
    'southExitId',
  );
  @override
  late final GeneratedColumn<int> southExitId = GeneratedColumn<int>(
    'south_exit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eastExitIdMeta = const VerificationMeta(
    'eastExitId',
  );
  @override
  late final GeneratedColumn<int> eastExitId = GeneratedColumn<int>(
    'east_exit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _westExitIdMeta = const VerificationMeta(
    'westExitId',
  );
  @override
  late final GeneratedColumn<int> westExitId = GeneratedColumn<int>(
    'west_exit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isExploredMeta = const VerificationMeta(
    'isExplored',
  );
  @override
  late final GeneratedColumn<bool> isExplored = GeneratedColumn<bool>(
    'is_explored',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_explored" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    act,
    title,
    description,
    imageAssetPath,
    northExitId,
    southExitId,
    eastExitId,
    westExitId,
    isExplored,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('act')) {
      context.handle(
        _actMeta,
        act.isAcceptableOrUnknown(data['act']!, _actMeta),
      );
    } else if (isInserting) {
      context.missing(_actMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('image_asset_path')) {
      context.handle(
        _imageAssetPathMeta,
        imageAssetPath.isAcceptableOrUnknown(
          data['image_asset_path']!,
          _imageAssetPathMeta,
        ),
      );
    }
    if (data.containsKey('north_exit_id')) {
      context.handle(
        _northExitIdMeta,
        northExitId.isAcceptableOrUnknown(
          data['north_exit_id']!,
          _northExitIdMeta,
        ),
      );
    }
    if (data.containsKey('south_exit_id')) {
      context.handle(
        _southExitIdMeta,
        southExitId.isAcceptableOrUnknown(
          data['south_exit_id']!,
          _southExitIdMeta,
        ),
      );
    }
    if (data.containsKey('east_exit_id')) {
      context.handle(
        _eastExitIdMeta,
        eastExitId.isAcceptableOrUnknown(
          data['east_exit_id']!,
          _eastExitIdMeta,
        ),
      );
    }
    if (data.containsKey('west_exit_id')) {
      context.handle(
        _westExitIdMeta,
        westExitId.isAcceptableOrUnknown(
          data['west_exit_id']!,
          _westExitIdMeta,
        ),
      );
    }
    if (data.containsKey('is_explored')) {
      context.handle(
        _isExploredMeta,
        isExplored.isAcceptableOrUnknown(data['is_explored']!, _isExploredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      act: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}act'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      imageAssetPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset_path'],
      ),
      northExitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}north_exit_id'],
      ),
      southExitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}south_exit_id'],
      ),
      eastExitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}east_exit_id'],
      ),
      westExitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}west_exit_id'],
      ),
      isExplored: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_explored'],
      )!,
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class RoomData extends DataClass implements Insertable<RoomData> {
  final int id;
  final int act;
  final String title;
  final String description;
  final String? imageAssetPath;
  final int? northExitId;
  final int? southExitId;
  final int? eastExitId;
  final int? westExitId;
  final bool isExplored;
  const RoomData({
    required this.id,
    required this.act,
    required this.title,
    required this.description,
    this.imageAssetPath,
    this.northExitId,
    this.southExitId,
    this.eastExitId,
    this.westExitId,
    required this.isExplored,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['act'] = Variable<int>(act);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || imageAssetPath != null) {
      map['image_asset_path'] = Variable<String>(imageAssetPath);
    }
    if (!nullToAbsent || northExitId != null) {
      map['north_exit_id'] = Variable<int>(northExitId);
    }
    if (!nullToAbsent || southExitId != null) {
      map['south_exit_id'] = Variable<int>(southExitId);
    }
    if (!nullToAbsent || eastExitId != null) {
      map['east_exit_id'] = Variable<int>(eastExitId);
    }
    if (!nullToAbsent || westExitId != null) {
      map['west_exit_id'] = Variable<int>(westExitId);
    }
    map['is_explored'] = Variable<bool>(isExplored);
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      act: Value(act),
      title: Value(title),
      description: Value(description),
      imageAssetPath: imageAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAssetPath),
      northExitId: northExitId == null && nullToAbsent
          ? const Value.absent()
          : Value(northExitId),
      southExitId: southExitId == null && nullToAbsent
          ? const Value.absent()
          : Value(southExitId),
      eastExitId: eastExitId == null && nullToAbsent
          ? const Value.absent()
          : Value(eastExitId),
      westExitId: westExitId == null && nullToAbsent
          ? const Value.absent()
          : Value(westExitId),
      isExplored: Value(isExplored),
    );
  }

  factory RoomData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomData(
      id: serializer.fromJson<int>(json['id']),
      act: serializer.fromJson<int>(json['act']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      imageAssetPath: serializer.fromJson<String?>(json['imageAssetPath']),
      northExitId: serializer.fromJson<int?>(json['northExitId']),
      southExitId: serializer.fromJson<int?>(json['southExitId']),
      eastExitId: serializer.fromJson<int?>(json['eastExitId']),
      westExitId: serializer.fromJson<int?>(json['westExitId']),
      isExplored: serializer.fromJson<bool>(json['isExplored']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'act': serializer.toJson<int>(act),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'imageAssetPath': serializer.toJson<String?>(imageAssetPath),
      'northExitId': serializer.toJson<int?>(northExitId),
      'southExitId': serializer.toJson<int?>(southExitId),
      'eastExitId': serializer.toJson<int?>(eastExitId),
      'westExitId': serializer.toJson<int?>(westExitId),
      'isExplored': serializer.toJson<bool>(isExplored),
    };
  }

  RoomData copyWith({
    int? id,
    int? act,
    String? title,
    String? description,
    Value<String?> imageAssetPath = const Value.absent(),
    Value<int?> northExitId = const Value.absent(),
    Value<int?> southExitId = const Value.absent(),
    Value<int?> eastExitId = const Value.absent(),
    Value<int?> westExitId = const Value.absent(),
    bool? isExplored,
  }) => RoomData(
    id: id ?? this.id,
    act: act ?? this.act,
    title: title ?? this.title,
    description: description ?? this.description,
    imageAssetPath: imageAssetPath.present
        ? imageAssetPath.value
        : this.imageAssetPath,
    northExitId: northExitId.present ? northExitId.value : this.northExitId,
    southExitId: southExitId.present ? southExitId.value : this.southExitId,
    eastExitId: eastExitId.present ? eastExitId.value : this.eastExitId,
    westExitId: westExitId.present ? westExitId.value : this.westExitId,
    isExplored: isExplored ?? this.isExplored,
  );
  RoomData copyWithCompanion(RoomsCompanion data) {
    return RoomData(
      id: data.id.present ? data.id.value : this.id,
      act: data.act.present ? data.act.value : this.act,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageAssetPath: data.imageAssetPath.present
          ? data.imageAssetPath.value
          : this.imageAssetPath,
      northExitId: data.northExitId.present
          ? data.northExitId.value
          : this.northExitId,
      southExitId: data.southExitId.present
          ? data.southExitId.value
          : this.southExitId,
      eastExitId: data.eastExitId.present
          ? data.eastExitId.value
          : this.eastExitId,
      westExitId: data.westExitId.present
          ? data.westExitId.value
          : this.westExitId,
      isExplored: data.isExplored.present
          ? data.isExplored.value
          : this.isExplored,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomData(')
          ..write('id: $id, ')
          ..write('act: $act, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('northExitId: $northExitId, ')
          ..write('southExitId: $southExitId, ')
          ..write('eastExitId: $eastExitId, ')
          ..write('westExitId: $westExitId, ')
          ..write('isExplored: $isExplored')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    act,
    title,
    description,
    imageAssetPath,
    northExitId,
    southExitId,
    eastExitId,
    westExitId,
    isExplored,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomData &&
          other.id == this.id &&
          other.act == this.act &&
          other.title == this.title &&
          other.description == this.description &&
          other.imageAssetPath == this.imageAssetPath &&
          other.northExitId == this.northExitId &&
          other.southExitId == this.southExitId &&
          other.eastExitId == this.eastExitId &&
          other.westExitId == this.westExitId &&
          other.isExplored == this.isExplored);
}

class RoomsCompanion extends UpdateCompanion<RoomData> {
  final Value<int> id;
  final Value<int> act;
  final Value<String> title;
  final Value<String> description;
  final Value<String?> imageAssetPath;
  final Value<int?> northExitId;
  final Value<int?> southExitId;
  final Value<int?> eastExitId;
  final Value<int?> westExitId;
  final Value<bool> isExplored;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.act = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    this.northExitId = const Value.absent(),
    this.southExitId = const Value.absent(),
    this.eastExitId = const Value.absent(),
    this.westExitId = const Value.absent(),
    this.isExplored = const Value.absent(),
  });
  RoomsCompanion.insert({
    this.id = const Value.absent(),
    required int act,
    required String title,
    required String description,
    this.imageAssetPath = const Value.absent(),
    this.northExitId = const Value.absent(),
    this.southExitId = const Value.absent(),
    this.eastExitId = const Value.absent(),
    this.westExitId = const Value.absent(),
    this.isExplored = const Value.absent(),
  }) : act = Value(act),
       title = Value(title),
       description = Value(description);
  static Insertable<RoomData> custom({
    Expression<int>? id,
    Expression<int>? act,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? imageAssetPath,
    Expression<int>? northExitId,
    Expression<int>? southExitId,
    Expression<int>? eastExitId,
    Expression<int>? westExitId,
    Expression<bool>? isExplored,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (act != null) 'act': act,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageAssetPath != null) 'image_asset_path': imageAssetPath,
      if (northExitId != null) 'north_exit_id': northExitId,
      if (southExitId != null) 'south_exit_id': southExitId,
      if (eastExitId != null) 'east_exit_id': eastExitId,
      if (westExitId != null) 'west_exit_id': westExitId,
      if (isExplored != null) 'is_explored': isExplored,
    });
  }

  RoomsCompanion copyWith({
    Value<int>? id,
    Value<int>? act,
    Value<String>? title,
    Value<String>? description,
    Value<String?>? imageAssetPath,
    Value<int?>? northExitId,
    Value<int?>? southExitId,
    Value<int?>? eastExitId,
    Value<int?>? westExitId,
    Value<bool>? isExplored,
  }) {
    return RoomsCompanion(
      id: id ?? this.id,
      act: act ?? this.act,
      title: title ?? this.title,
      description: description ?? this.description,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      northExitId: northExitId ?? this.northExitId,
      southExitId: southExitId ?? this.southExitId,
      eastExitId: eastExitId ?? this.eastExitId,
      westExitId: westExitId ?? this.westExitId,
      isExplored: isExplored ?? this.isExplored,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (act.present) {
      map['act'] = Variable<int>(act.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageAssetPath.present) {
      map['image_asset_path'] = Variable<String>(imageAssetPath.value);
    }
    if (northExitId.present) {
      map['north_exit_id'] = Variable<int>(northExitId.value);
    }
    if (southExitId.present) {
      map['south_exit_id'] = Variable<int>(southExitId.value);
    }
    if (eastExitId.present) {
      map['east_exit_id'] = Variable<int>(eastExitId.value);
    }
    if (westExitId.present) {
      map['west_exit_id'] = Variable<int>(westExitId.value);
    }
    if (isExplored.present) {
      map['is_explored'] = Variable<bool>(isExplored.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('act: $act, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('northExitId: $northExitId, ')
          ..write('southExitId: $southExitId, ')
          ..write('eastExitId: $eastExitId, ')
          ..write('westExitId: $westExitId, ')
          ..write('isExplored: $isExplored')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, ItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groundRoomIdMeta = const VerificationMeta(
    'groundRoomId',
  );
  @override
  late final GeneratedColumn<int> groundRoomId = GeneratedColumn<int>(
    'ground_room_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseTypeMeta = const VerificationMeta(
    'baseType',
  );
  @override
  late final GeneratedColumn<String> baseType = GeneratedColumn<String>(
    'base_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Normal'),
  );
  static const VerificationMeta _isEquippedMeta = const VerificationMeta(
    'isEquipped',
  );
  @override
  late final GeneratedColumn<bool> isEquipped = GeneratedColumn<bool>(
    'is_equipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_equipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _equipSlotMeta = const VerificationMeta(
    'equipSlot',
  );
  @override
  late final GeneratedColumn<String> equipSlot = GeneratedColumn<String>(
    'equip_slot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minDamageMeta = const VerificationMeta(
    'minDamage',
  );
  @override
  late final GeneratedColumn<int> minDamage = GeneratedColumn<int>(
    'min_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxDamageMeta = const VerificationMeta(
    'maxDamage',
  );
  @override
  late final GeneratedColumn<int> maxDamage = GeneratedColumn<int>(
    'max_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _armorValueMeta = const VerificationMeta(
    'armorValue',
  );
  @override
  late final GeneratedColumn<int> armorValue = GeneratedColumn<int>(
    'armor_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _socketCountMeta = const VerificationMeta(
    'socketCount',
  );
  @override
  late final GeneratedColumn<int> socketCount = GeneratedColumn<int>(
    'socket_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _modifiersJsonMeta = const VerificationMeta(
    'modifiersJson',
  );
  @override
  late final GeneratedColumn<String> modifiersJson = GeneratedColumn<String>(
    'modifiers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    groundRoomId,
    name,
    baseType,
    rarity,
    isEquipped,
    equipSlot,
    minDamage,
    maxDamage,
    armorValue,
    socketCount,
    modifiersJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('ground_room_id')) {
      context.handle(
        _groundRoomIdMeta,
        groundRoomId.isAcceptableOrUnknown(
          data['ground_room_id']!,
          _groundRoomIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_type')) {
      context.handle(
        _baseTypeMeta,
        baseType.isAcceptableOrUnknown(data['base_type']!, _baseTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_baseTypeMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    }
    if (data.containsKey('is_equipped')) {
      context.handle(
        _isEquippedMeta,
        isEquipped.isAcceptableOrUnknown(data['is_equipped']!, _isEquippedMeta),
      );
    }
    if (data.containsKey('equip_slot')) {
      context.handle(
        _equipSlotMeta,
        equipSlot.isAcceptableOrUnknown(data['equip_slot']!, _equipSlotMeta),
      );
    }
    if (data.containsKey('min_damage')) {
      context.handle(
        _minDamageMeta,
        minDamage.isAcceptableOrUnknown(data['min_damage']!, _minDamageMeta),
      );
    }
    if (data.containsKey('max_damage')) {
      context.handle(
        _maxDamageMeta,
        maxDamage.isAcceptableOrUnknown(data['max_damage']!, _maxDamageMeta),
      );
    }
    if (data.containsKey('armor_value')) {
      context.handle(
        _armorValueMeta,
        armorValue.isAcceptableOrUnknown(data['armor_value']!, _armorValueMeta),
      );
    }
    if (data.containsKey('socket_count')) {
      context.handle(
        _socketCountMeta,
        socketCount.isAcceptableOrUnknown(
          data['socket_count']!,
          _socketCountMeta,
        ),
      );
    }
    if (data.containsKey('modifiers_json')) {
      context.handle(
        _modifiersJsonMeta,
        modifiersJson.isAcceptableOrUnknown(
          data['modifiers_json']!,
          _modifiersJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id'],
      ),
      groundRoomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ground_room_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      baseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_type'],
      )!,
      rarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rarity'],
      )!,
      isEquipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_equipped'],
      )!,
      equipSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equip_slot'],
      ),
      minDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_damage'],
      )!,
      maxDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_damage'],
      )!,
      armorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}armor_value'],
      )!,
      socketCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}socket_count'],
      )!,
      modifiersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modifiers_json'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class ItemData extends DataClass implements Insertable<ItemData> {
  final String id;
  final int? ownerId;
  final int? groundRoomId;
  final String name;
  final String baseType;
  final String rarity;
  final bool isEquipped;
  final String? equipSlot;
  final int minDamage;
  final int maxDamage;
  final int armorValue;
  final int socketCount;
  final String modifiersJson;
  const ItemData({
    required this.id,
    this.ownerId,
    this.groundRoomId,
    required this.name,
    required this.baseType,
    required this.rarity,
    required this.isEquipped,
    this.equipSlot,
    required this.minDamage,
    required this.maxDamage,
    required this.armorValue,
    required this.socketCount,
    required this.modifiersJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<int>(ownerId);
    }
    if (!nullToAbsent || groundRoomId != null) {
      map['ground_room_id'] = Variable<int>(groundRoomId);
    }
    map['name'] = Variable<String>(name);
    map['base_type'] = Variable<String>(baseType);
    map['rarity'] = Variable<String>(rarity);
    map['is_equipped'] = Variable<bool>(isEquipped);
    if (!nullToAbsent || equipSlot != null) {
      map['equip_slot'] = Variable<String>(equipSlot);
    }
    map['min_damage'] = Variable<int>(minDamage);
    map['max_damage'] = Variable<int>(maxDamage);
    map['armor_value'] = Variable<int>(armorValue);
    map['socket_count'] = Variable<int>(socketCount);
    map['modifiers_json'] = Variable<String>(modifiersJson);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      groundRoomId: groundRoomId == null && nullToAbsent
          ? const Value.absent()
          : Value(groundRoomId),
      name: Value(name),
      baseType: Value(baseType),
      rarity: Value(rarity),
      isEquipped: Value(isEquipped),
      equipSlot: equipSlot == null && nullToAbsent
          ? const Value.absent()
          : Value(equipSlot),
      minDamage: Value(minDamage),
      maxDamage: Value(maxDamage),
      armorValue: Value(armorValue),
      socketCount: Value(socketCount),
      modifiersJson: Value(modifiersJson),
    );
  }

  factory ItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemData(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<int?>(json['ownerId']),
      groundRoomId: serializer.fromJson<int?>(json['groundRoomId']),
      name: serializer.fromJson<String>(json['name']),
      baseType: serializer.fromJson<String>(json['baseType']),
      rarity: serializer.fromJson<String>(json['rarity']),
      isEquipped: serializer.fromJson<bool>(json['isEquipped']),
      equipSlot: serializer.fromJson<String?>(json['equipSlot']),
      minDamage: serializer.fromJson<int>(json['minDamage']),
      maxDamage: serializer.fromJson<int>(json['maxDamage']),
      armorValue: serializer.fromJson<int>(json['armorValue']),
      socketCount: serializer.fromJson<int>(json['socketCount']),
      modifiersJson: serializer.fromJson<String>(json['modifiersJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<int?>(ownerId),
      'groundRoomId': serializer.toJson<int?>(groundRoomId),
      'name': serializer.toJson<String>(name),
      'baseType': serializer.toJson<String>(baseType),
      'rarity': serializer.toJson<String>(rarity),
      'isEquipped': serializer.toJson<bool>(isEquipped),
      'equipSlot': serializer.toJson<String?>(equipSlot),
      'minDamage': serializer.toJson<int>(minDamage),
      'maxDamage': serializer.toJson<int>(maxDamage),
      'armorValue': serializer.toJson<int>(armorValue),
      'socketCount': serializer.toJson<int>(socketCount),
      'modifiersJson': serializer.toJson<String>(modifiersJson),
    };
  }

  ItemData copyWith({
    String? id,
    Value<int?> ownerId = const Value.absent(),
    Value<int?> groundRoomId = const Value.absent(),
    String? name,
    String? baseType,
    String? rarity,
    bool? isEquipped,
    Value<String?> equipSlot = const Value.absent(),
    int? minDamage,
    int? maxDamage,
    int? armorValue,
    int? socketCount,
    String? modifiersJson,
  }) => ItemData(
    id: id ?? this.id,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    groundRoomId: groundRoomId.present ? groundRoomId.value : this.groundRoomId,
    name: name ?? this.name,
    baseType: baseType ?? this.baseType,
    rarity: rarity ?? this.rarity,
    isEquipped: isEquipped ?? this.isEquipped,
    equipSlot: equipSlot.present ? equipSlot.value : this.equipSlot,
    minDamage: minDamage ?? this.minDamage,
    maxDamage: maxDamage ?? this.maxDamage,
    armorValue: armorValue ?? this.armorValue,
    socketCount: socketCount ?? this.socketCount,
    modifiersJson: modifiersJson ?? this.modifiersJson,
  );
  ItemData copyWithCompanion(ItemsCompanion data) {
    return ItemData(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      groundRoomId: data.groundRoomId.present
          ? data.groundRoomId.value
          : this.groundRoomId,
      name: data.name.present ? data.name.value : this.name,
      baseType: data.baseType.present ? data.baseType.value : this.baseType,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      isEquipped: data.isEquipped.present
          ? data.isEquipped.value
          : this.isEquipped,
      equipSlot: data.equipSlot.present ? data.equipSlot.value : this.equipSlot,
      minDamage: data.minDamage.present ? data.minDamage.value : this.minDamage,
      maxDamage: data.maxDamage.present ? data.maxDamage.value : this.maxDamage,
      armorValue: data.armorValue.present
          ? data.armorValue.value
          : this.armorValue,
      socketCount: data.socketCount.present
          ? data.socketCount.value
          : this.socketCount,
      modifiersJson: data.modifiersJson.present
          ? data.modifiersJson.value
          : this.modifiersJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemData(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('groundRoomId: $groundRoomId, ')
          ..write('name: $name, ')
          ..write('baseType: $baseType, ')
          ..write('rarity: $rarity, ')
          ..write('isEquipped: $isEquipped, ')
          ..write('equipSlot: $equipSlot, ')
          ..write('minDamage: $minDamage, ')
          ..write('maxDamage: $maxDamage, ')
          ..write('armorValue: $armorValue, ')
          ..write('socketCount: $socketCount, ')
          ..write('modifiersJson: $modifiersJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    groundRoomId,
    name,
    baseType,
    rarity,
    isEquipped,
    equipSlot,
    minDamage,
    maxDamage,
    armorValue,
    socketCount,
    modifiersJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemData &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.groundRoomId == this.groundRoomId &&
          other.name == this.name &&
          other.baseType == this.baseType &&
          other.rarity == this.rarity &&
          other.isEquipped == this.isEquipped &&
          other.equipSlot == this.equipSlot &&
          other.minDamage == this.minDamage &&
          other.maxDamage == this.maxDamage &&
          other.armorValue == this.armorValue &&
          other.socketCount == this.socketCount &&
          other.modifiersJson == this.modifiersJson);
}

class ItemsCompanion extends UpdateCompanion<ItemData> {
  final Value<String> id;
  final Value<int?> ownerId;
  final Value<int?> groundRoomId;
  final Value<String> name;
  final Value<String> baseType;
  final Value<String> rarity;
  final Value<bool> isEquipped;
  final Value<String?> equipSlot;
  final Value<int> minDamage;
  final Value<int> maxDamage;
  final Value<int> armorValue;
  final Value<int> socketCount;
  final Value<String> modifiersJson;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.groundRoomId = const Value.absent(),
    this.name = const Value.absent(),
    this.baseType = const Value.absent(),
    this.rarity = const Value.absent(),
    this.isEquipped = const Value.absent(),
    this.equipSlot = const Value.absent(),
    this.minDamage = const Value.absent(),
    this.maxDamage = const Value.absent(),
    this.armorValue = const Value.absent(),
    this.socketCount = const Value.absent(),
    this.modifiersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    this.ownerId = const Value.absent(),
    this.groundRoomId = const Value.absent(),
    required String name,
    required String baseType,
    this.rarity = const Value.absent(),
    this.isEquipped = const Value.absent(),
    this.equipSlot = const Value.absent(),
    this.minDamage = const Value.absent(),
    this.maxDamage = const Value.absent(),
    this.armorValue = const Value.absent(),
    this.socketCount = const Value.absent(),
    this.modifiersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       baseType = Value(baseType);
  static Insertable<ItemData> custom({
    Expression<String>? id,
    Expression<int>? ownerId,
    Expression<int>? groundRoomId,
    Expression<String>? name,
    Expression<String>? baseType,
    Expression<String>? rarity,
    Expression<bool>? isEquipped,
    Expression<String>? equipSlot,
    Expression<int>? minDamage,
    Expression<int>? maxDamage,
    Expression<int>? armorValue,
    Expression<int>? socketCount,
    Expression<String>? modifiersJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (groundRoomId != null) 'ground_room_id': groundRoomId,
      if (name != null) 'name': name,
      if (baseType != null) 'base_type': baseType,
      if (rarity != null) 'rarity': rarity,
      if (isEquipped != null) 'is_equipped': isEquipped,
      if (equipSlot != null) 'equip_slot': equipSlot,
      if (minDamage != null) 'min_damage': minDamage,
      if (maxDamage != null) 'max_damage': maxDamage,
      if (armorValue != null) 'armor_value': armorValue,
      if (socketCount != null) 'socket_count': socketCount,
      if (modifiersJson != null) 'modifiers_json': modifiersJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith({
    Value<String>? id,
    Value<int?>? ownerId,
    Value<int?>? groundRoomId,
    Value<String>? name,
    Value<String>? baseType,
    Value<String>? rarity,
    Value<bool>? isEquipped,
    Value<String?>? equipSlot,
    Value<int>? minDamage,
    Value<int>? maxDamage,
    Value<int>? armorValue,
    Value<int>? socketCount,
    Value<String>? modifiersJson,
    Value<int>? rowid,
  }) {
    return ItemsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      groundRoomId: groundRoomId ?? this.groundRoomId,
      name: name ?? this.name,
      baseType: baseType ?? this.baseType,
      rarity: rarity ?? this.rarity,
      isEquipped: isEquipped ?? this.isEquipped,
      equipSlot: equipSlot ?? this.equipSlot,
      minDamage: minDamage ?? this.minDamage,
      maxDamage: maxDamage ?? this.maxDamage,
      armorValue: armorValue ?? this.armorValue,
      socketCount: socketCount ?? this.socketCount,
      modifiersJson: modifiersJson ?? this.modifiersJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (groundRoomId.present) {
      map['ground_room_id'] = Variable<int>(groundRoomId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (baseType.present) {
      map['base_type'] = Variable<String>(baseType.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (isEquipped.present) {
      map['is_equipped'] = Variable<bool>(isEquipped.value);
    }
    if (equipSlot.present) {
      map['equip_slot'] = Variable<String>(equipSlot.value);
    }
    if (minDamage.present) {
      map['min_damage'] = Variable<int>(minDamage.value);
    }
    if (maxDamage.present) {
      map['max_damage'] = Variable<int>(maxDamage.value);
    }
    if (armorValue.present) {
      map['armor_value'] = Variable<int>(armorValue.value);
    }
    if (socketCount.present) {
      map['socket_count'] = Variable<int>(socketCount.value);
    }
    if (modifiersJson.present) {
      map['modifiers_json'] = Variable<String>(modifiersJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('groundRoomId: $groundRoomId, ')
          ..write('name: $name, ')
          ..write('baseType: $baseType, ')
          ..write('rarity: $rarity, ')
          ..write('isEquipped: $isEquipped, ')
          ..write('equipSlot: $equipSlot, ')
          ..write('minDamage: $minDamage, ')
          ..write('maxDamage: $maxDamage, ')
          ..write('armorValue: $armorValue, ')
          ..write('socketCount: $socketCount, ')
          ..write('modifiersJson: $modifiersJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MobsTable extends Mobs with TableInfo<$MobsTable, MobData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<int> roomId = GeneratedColumn<int>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxHpMeta = const VerificationMeta('maxHp');
  @override
  late final GeneratedColumn<int> maxHp = GeneratedColumn<int>(
    'max_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentHpMeta = const VerificationMeta(
    'currentHp',
  );
  @override
  late final GeneratedColumn<int> currentHp = GeneratedColumn<int>(
    'current_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minDamageMeta = const VerificationMeta(
    'minDamage',
  );
  @override
  late final GeneratedColumn<int> minDamage = GeneratedColumn<int>(
    'min_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxDamageMeta = const VerificationMeta(
    'maxDamage',
  );
  @override
  late final GeneratedColumn<int> maxDamage = GeneratedColumn<int>(
    'max_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armorMeta = const VerificationMeta('armor');
  @override
  late final GeneratedColumn<int> armor = GeneratedColumn<int>(
    'armor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _expRewardMeta = const VerificationMeta(
    'expReward',
  );
  @override
  late final GeneratedColumn<int> expReward = GeneratedColumn<int>(
    'exp_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAliveMeta = const VerificationMeta(
    'isAlive',
  );
  @override
  late final GeneratedColumn<bool> isAlive = GeneratedColumn<bool>(
    'is_alive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_alive" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dropTableJsonMeta = const VerificationMeta(
    'dropTableJson',
  );
  @override
  late final GeneratedColumn<String> dropTableJson = GeneratedColumn<String>(
    'drop_table_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    name,
    level,
    maxHp,
    currentHp,
    minDamage,
    maxDamage,
    armor,
    expReward,
    isAlive,
    dropTableJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MobData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('max_hp')) {
      context.handle(
        _maxHpMeta,
        maxHp.isAcceptableOrUnknown(data['max_hp']!, _maxHpMeta),
      );
    } else if (isInserting) {
      context.missing(_maxHpMeta);
    }
    if (data.containsKey('current_hp')) {
      context.handle(
        _currentHpMeta,
        currentHp.isAcceptableOrUnknown(data['current_hp']!, _currentHpMeta),
      );
    } else if (isInserting) {
      context.missing(_currentHpMeta);
    }
    if (data.containsKey('min_damage')) {
      context.handle(
        _minDamageMeta,
        minDamage.isAcceptableOrUnknown(data['min_damage']!, _minDamageMeta),
      );
    } else if (isInserting) {
      context.missing(_minDamageMeta);
    }
    if (data.containsKey('max_damage')) {
      context.handle(
        _maxDamageMeta,
        maxDamage.isAcceptableOrUnknown(data['max_damage']!, _maxDamageMeta),
      );
    } else if (isInserting) {
      context.missing(_maxDamageMeta);
    }
    if (data.containsKey('armor')) {
      context.handle(
        _armorMeta,
        armor.isAcceptableOrUnknown(data['armor']!, _armorMeta),
      );
    }
    if (data.containsKey('exp_reward')) {
      context.handle(
        _expRewardMeta,
        expReward.isAcceptableOrUnknown(data['exp_reward']!, _expRewardMeta),
      );
    } else if (isInserting) {
      context.missing(_expRewardMeta);
    }
    if (data.containsKey('is_alive')) {
      context.handle(
        _isAliveMeta,
        isAlive.isAcceptableOrUnknown(data['is_alive']!, _isAliveMeta),
      );
    }
    if (data.containsKey('drop_table_json')) {
      context.handle(
        _dropTableJsonMeta,
        dropTableJson.isAcceptableOrUnknown(
          data['drop_table_json']!,
          _dropTableJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MobData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MobData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      maxHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_hp'],
      )!,
      currentHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_hp'],
      )!,
      minDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_damage'],
      )!,
      maxDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_damage'],
      )!,
      armor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}armor'],
      )!,
      expReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp_reward'],
      )!,
      isAlive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_alive'],
      )!,
      dropTableJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drop_table_json'],
      )!,
    );
  }

  @override
  $MobsTable createAlias(String alias) {
    return $MobsTable(attachedDatabase, alias);
  }
}

class MobData extends DataClass implements Insertable<MobData> {
  final int id;
  final int roomId;
  final String name;
  final int level;
  final int maxHp;
  final int currentHp;
  final int minDamage;
  final int maxDamage;
  final int armor;
  final int expReward;
  final bool isAlive;
  final String dropTableJson;
  const MobData({
    required this.id,
    required this.roomId,
    required this.name,
    required this.level,
    required this.maxHp,
    required this.currentHp,
    required this.minDamage,
    required this.maxDamage,
    required this.armor,
    required this.expReward,
    required this.isAlive,
    required this.dropTableJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['room_id'] = Variable<int>(roomId);
    map['name'] = Variable<String>(name);
    map['level'] = Variable<int>(level);
    map['max_hp'] = Variable<int>(maxHp);
    map['current_hp'] = Variable<int>(currentHp);
    map['min_damage'] = Variable<int>(minDamage);
    map['max_damage'] = Variable<int>(maxDamage);
    map['armor'] = Variable<int>(armor);
    map['exp_reward'] = Variable<int>(expReward);
    map['is_alive'] = Variable<bool>(isAlive);
    map['drop_table_json'] = Variable<String>(dropTableJson);
    return map;
  }

  MobsCompanion toCompanion(bool nullToAbsent) {
    return MobsCompanion(
      id: Value(id),
      roomId: Value(roomId),
      name: Value(name),
      level: Value(level),
      maxHp: Value(maxHp),
      currentHp: Value(currentHp),
      minDamage: Value(minDamage),
      maxDamage: Value(maxDamage),
      armor: Value(armor),
      expReward: Value(expReward),
      isAlive: Value(isAlive),
      dropTableJson: Value(dropTableJson),
    );
  }

  factory MobData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MobData(
      id: serializer.fromJson<int>(json['id']),
      roomId: serializer.fromJson<int>(json['roomId']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<int>(json['level']),
      maxHp: serializer.fromJson<int>(json['maxHp']),
      currentHp: serializer.fromJson<int>(json['currentHp']),
      minDamage: serializer.fromJson<int>(json['minDamage']),
      maxDamage: serializer.fromJson<int>(json['maxDamage']),
      armor: serializer.fromJson<int>(json['armor']),
      expReward: serializer.fromJson<int>(json['expReward']),
      isAlive: serializer.fromJson<bool>(json['isAlive']),
      dropTableJson: serializer.fromJson<String>(json['dropTableJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roomId': serializer.toJson<int>(roomId),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<int>(level),
      'maxHp': serializer.toJson<int>(maxHp),
      'currentHp': serializer.toJson<int>(currentHp),
      'minDamage': serializer.toJson<int>(minDamage),
      'maxDamage': serializer.toJson<int>(maxDamage),
      'armor': serializer.toJson<int>(armor),
      'expReward': serializer.toJson<int>(expReward),
      'isAlive': serializer.toJson<bool>(isAlive),
      'dropTableJson': serializer.toJson<String>(dropTableJson),
    };
  }

  MobData copyWith({
    int? id,
    int? roomId,
    String? name,
    int? level,
    int? maxHp,
    int? currentHp,
    int? minDamage,
    int? maxDamage,
    int? armor,
    int? expReward,
    bool? isAlive,
    String? dropTableJson,
  }) => MobData(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    name: name ?? this.name,
    level: level ?? this.level,
    maxHp: maxHp ?? this.maxHp,
    currentHp: currentHp ?? this.currentHp,
    minDamage: minDamage ?? this.minDamage,
    maxDamage: maxDamage ?? this.maxDamage,
    armor: armor ?? this.armor,
    expReward: expReward ?? this.expReward,
    isAlive: isAlive ?? this.isAlive,
    dropTableJson: dropTableJson ?? this.dropTableJson,
  );
  MobData copyWithCompanion(MobsCompanion data) {
    return MobData(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      maxHp: data.maxHp.present ? data.maxHp.value : this.maxHp,
      currentHp: data.currentHp.present ? data.currentHp.value : this.currentHp,
      minDamage: data.minDamage.present ? data.minDamage.value : this.minDamage,
      maxDamage: data.maxDamage.present ? data.maxDamage.value : this.maxDamage,
      armor: data.armor.present ? data.armor.value : this.armor,
      expReward: data.expReward.present ? data.expReward.value : this.expReward,
      isAlive: data.isAlive.present ? data.isAlive.value : this.isAlive,
      dropTableJson: data.dropTableJson.present
          ? data.dropTableJson.value
          : this.dropTableJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MobData(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('maxHp: $maxHp, ')
          ..write('currentHp: $currentHp, ')
          ..write('minDamage: $minDamage, ')
          ..write('maxDamage: $maxDamage, ')
          ..write('armor: $armor, ')
          ..write('expReward: $expReward, ')
          ..write('isAlive: $isAlive, ')
          ..write('dropTableJson: $dropTableJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roomId,
    name,
    level,
    maxHp,
    currentHp,
    minDamage,
    maxDamage,
    armor,
    expReward,
    isAlive,
    dropTableJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MobData &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.name == this.name &&
          other.level == this.level &&
          other.maxHp == this.maxHp &&
          other.currentHp == this.currentHp &&
          other.minDamage == this.minDamage &&
          other.maxDamage == this.maxDamage &&
          other.armor == this.armor &&
          other.expReward == this.expReward &&
          other.isAlive == this.isAlive &&
          other.dropTableJson == this.dropTableJson);
}

class MobsCompanion extends UpdateCompanion<MobData> {
  final Value<int> id;
  final Value<int> roomId;
  final Value<String> name;
  final Value<int> level;
  final Value<int> maxHp;
  final Value<int> currentHp;
  final Value<int> minDamage;
  final Value<int> maxDamage;
  final Value<int> armor;
  final Value<int> expReward;
  final Value<bool> isAlive;
  final Value<String> dropTableJson;
  const MobsCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.maxHp = const Value.absent(),
    this.currentHp = const Value.absent(),
    this.minDamage = const Value.absent(),
    this.maxDamage = const Value.absent(),
    this.armor = const Value.absent(),
    this.expReward = const Value.absent(),
    this.isAlive = const Value.absent(),
    this.dropTableJson = const Value.absent(),
  });
  MobsCompanion.insert({
    this.id = const Value.absent(),
    required int roomId,
    required String name,
    required int level,
    required int maxHp,
    required int currentHp,
    required int minDamage,
    required int maxDamage,
    this.armor = const Value.absent(),
    required int expReward,
    this.isAlive = const Value.absent(),
    this.dropTableJson = const Value.absent(),
  }) : roomId = Value(roomId),
       name = Value(name),
       level = Value(level),
       maxHp = Value(maxHp),
       currentHp = Value(currentHp),
       minDamage = Value(minDamage),
       maxDamage = Value(maxDamage),
       expReward = Value(expReward);
  static Insertable<MobData> custom({
    Expression<int>? id,
    Expression<int>? roomId,
    Expression<String>? name,
    Expression<int>? level,
    Expression<int>? maxHp,
    Expression<int>? currentHp,
    Expression<int>? minDamage,
    Expression<int>? maxDamage,
    Expression<int>? armor,
    Expression<int>? expReward,
    Expression<bool>? isAlive,
    Expression<String>? dropTableJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (maxHp != null) 'max_hp': maxHp,
      if (currentHp != null) 'current_hp': currentHp,
      if (minDamage != null) 'min_damage': minDamage,
      if (maxDamage != null) 'max_damage': maxDamage,
      if (armor != null) 'armor': armor,
      if (expReward != null) 'exp_reward': expReward,
      if (isAlive != null) 'is_alive': isAlive,
      if (dropTableJson != null) 'drop_table_json': dropTableJson,
    });
  }

  MobsCompanion copyWith({
    Value<int>? id,
    Value<int>? roomId,
    Value<String>? name,
    Value<int>? level,
    Value<int>? maxHp,
    Value<int>? currentHp,
    Value<int>? minDamage,
    Value<int>? maxDamage,
    Value<int>? armor,
    Value<int>? expReward,
    Value<bool>? isAlive,
    Value<String>? dropTableJson,
  }) {
    return MobsCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      level: level ?? this.level,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      minDamage: minDamage ?? this.minDamage,
      maxDamage: maxDamage ?? this.maxDamage,
      armor: armor ?? this.armor,
      expReward: expReward ?? this.expReward,
      isAlive: isAlive ?? this.isAlive,
      dropTableJson: dropTableJson ?? this.dropTableJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<int>(roomId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (maxHp.present) {
      map['max_hp'] = Variable<int>(maxHp.value);
    }
    if (currentHp.present) {
      map['current_hp'] = Variable<int>(currentHp.value);
    }
    if (minDamage.present) {
      map['min_damage'] = Variable<int>(minDamage.value);
    }
    if (maxDamage.present) {
      map['max_damage'] = Variable<int>(maxDamage.value);
    }
    if (armor.present) {
      map['armor'] = Variable<int>(armor.value);
    }
    if (expReward.present) {
      map['exp_reward'] = Variable<int>(expReward.value);
    }
    if (isAlive.present) {
      map['is_alive'] = Variable<bool>(isAlive.value);
    }
    if (dropTableJson.present) {
      map['drop_table_json'] = Variable<String>(dropTableJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MobsCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('maxHp: $maxHp, ')
          ..write('currentHp: $currentHp, ')
          ..write('minDamage: $minDamage, ')
          ..write('maxDamage: $maxDamage, ')
          ..write('armor: $armor, ')
          ..write('expReward: $expReward, ')
          ..write('isAlive: $isAlive, ')
          ..write('dropTableJson: $dropTableJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $MobsTable mobs = $MobsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    players,
    rooms,
    items,
    mobs,
  ];
}

typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required String name,
      Value<String> jobClass,
      Value<int> level,
      Value<int> currentExp,
      Value<int> maxExp,
      Value<int> baseHp,
      Value<int> currentHp,
      Value<int> strength,
      Value<int> agility,
      Value<int> intelligence,
      Value<int> currentRoomId,
      Value<int> silverPrisms,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> jobClass,
      Value<int> level,
      Value<int> currentExp,
      Value<int> maxExp,
      Value<int> baseHp,
      Value<int> currentHp,
      Value<int> strength,
      Value<int> agility,
      Value<int> intelligence,
      Value<int> currentRoomId,
      Value<int> silverPrisms,
    });

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobClass => $composableBuilder(
    column: $table.jobClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentExp => $composableBuilder(
    column: $table.currentExp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxExp => $composableBuilder(
    column: $table.maxExp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseHp => $composableBuilder(
    column: $table.baseHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get agility => $composableBuilder(
    column: $table.agility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentRoomId => $composableBuilder(
    column: $table.currentRoomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get silverPrisms => $composableBuilder(
    column: $table.silverPrisms,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobClass => $composableBuilder(
    column: $table.jobClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentExp => $composableBuilder(
    column: $table.currentExp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxExp => $composableBuilder(
    column: $table.maxExp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseHp => $composableBuilder(
    column: $table.baseHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get agility => $composableBuilder(
    column: $table.agility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentRoomId => $composableBuilder(
    column: $table.currentRoomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get silverPrisms => $composableBuilder(
    column: $table.silverPrisms,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get jobClass =>
      $composableBuilder(column: $table.jobClass, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get currentExp => $composableBuilder(
    column: $table.currentExp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxExp =>
      $composableBuilder(column: $table.maxExp, builder: (column) => column);

  GeneratedColumn<int> get baseHp =>
      $composableBuilder(column: $table.baseHp, builder: (column) => column);

  GeneratedColumn<int> get currentHp =>
      $composableBuilder(column: $table.currentHp, builder: (column) => column);

  GeneratedColumn<int> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<int> get agility =>
      $composableBuilder(column: $table.agility, builder: (column) => column);

  GeneratedColumn<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentRoomId => $composableBuilder(
    column: $table.currentRoomId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get silverPrisms => $composableBuilder(
    column: $table.silverPrisms,
    builder: (column) => column,
  );
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          PlayerData,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (
            PlayerData,
            BaseReferences<_$AppDatabase, $PlayersTable, PlayerData>,
          ),
          PlayerData,
          PrefetchHooks Function()
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> jobClass = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> currentExp = const Value.absent(),
                Value<int> maxExp = const Value.absent(),
                Value<int> baseHp = const Value.absent(),
                Value<int> currentHp = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> agility = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> currentRoomId = const Value.absent(),
                Value<int> silverPrisms = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                name: name,
                jobClass: jobClass,
                level: level,
                currentExp: currentExp,
                maxExp: maxExp,
                baseHp: baseHp,
                currentHp: currentHp,
                strength: strength,
                agility: agility,
                intelligence: intelligence,
                currentRoomId: currentRoomId,
                silverPrisms: silverPrisms,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> jobClass = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> currentExp = const Value.absent(),
                Value<int> maxExp = const Value.absent(),
                Value<int> baseHp = const Value.absent(),
                Value<int> currentHp = const Value.absent(),
                Value<int> strength = const Value.absent(),
                Value<int> agility = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> currentRoomId = const Value.absent(),
                Value<int> silverPrisms = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                name: name,
                jobClass: jobClass,
                level: level,
                currentExp: currentExp,
                maxExp: maxExp,
                baseHp: baseHp,
                currentHp: currentHp,
                strength: strength,
                agility: agility,
                intelligence: intelligence,
                currentRoomId: currentRoomId,
                silverPrisms: silverPrisms,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlayersTable, PlayerData>(table),
                  BaseReferences<_$AppDatabase, $PlayersTable, PlayerData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      PlayerData,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (PlayerData, BaseReferences<_$AppDatabase, $PlayersTable, PlayerData>),
      PlayerData,
      PrefetchHooks Function()
    >;
typedef $$RoomsTableCreateCompanionBuilder =
    RoomsCompanion Function({
      Value<int> id,
      required int act,
      required String title,
      required String description,
      Value<String?> imageAssetPath,
      Value<int?> northExitId,
      Value<int?> southExitId,
      Value<int?> eastExitId,
      Value<int?> westExitId,
      Value<bool> isExplored,
    });
typedef $$RoomsTableUpdateCompanionBuilder =
    RoomsCompanion Function({
      Value<int> id,
      Value<int> act,
      Value<String> title,
      Value<String> description,
      Value<String?> imageAssetPath,
      Value<int?> northExitId,
      Value<int?> southExitId,
      Value<int?> eastExitId,
      Value<int?> westExitId,
      Value<bool> isExplored,
    });

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get act => $composableBuilder(
    column: $table.act,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAssetPath => $composableBuilder(
    column: $table.imageAssetPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get northExitId => $composableBuilder(
    column: $table.northExitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get southExitId => $composableBuilder(
    column: $table.southExitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eastExitId => $composableBuilder(
    column: $table.eastExitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get westExitId => $composableBuilder(
    column: $table.westExitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isExplored => $composableBuilder(
    column: $table.isExplored,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get act => $composableBuilder(
    column: $table.act,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAssetPath => $composableBuilder(
    column: $table.imageAssetPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get northExitId => $composableBuilder(
    column: $table.northExitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get southExitId => $composableBuilder(
    column: $table.southExitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eastExitId => $composableBuilder(
    column: $table.eastExitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get westExitId => $composableBuilder(
    column: $table.westExitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isExplored => $composableBuilder(
    column: $table.isExplored,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get act =>
      $composableBuilder(column: $table.act, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAssetPath => $composableBuilder(
    column: $table.imageAssetPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get northExitId => $composableBuilder(
    column: $table.northExitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get southExitId => $composableBuilder(
    column: $table.southExitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eastExitId => $composableBuilder(
    column: $table.eastExitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get westExitId => $composableBuilder(
    column: $table.westExitId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isExplored => $composableBuilder(
    column: $table.isExplored,
    builder: (column) => column,
  );
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          RoomData,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (RoomData, BaseReferences<_$AppDatabase, $RoomsTable, RoomData>),
          RoomData,
          PrefetchHooks Function()
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> act = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> imageAssetPath = const Value.absent(),
                Value<int?> northExitId = const Value.absent(),
                Value<int?> southExitId = const Value.absent(),
                Value<int?> eastExitId = const Value.absent(),
                Value<int?> westExitId = const Value.absent(),
                Value<bool> isExplored = const Value.absent(),
              }) => RoomsCompanion(
                id: id,
                act: act,
                title: title,
                description: description,
                imageAssetPath: imageAssetPath,
                northExitId: northExitId,
                southExitId: southExitId,
                eastExitId: eastExitId,
                westExitId: westExitId,
                isExplored: isExplored,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int act,
                required String title,
                required String description,
                Value<String?> imageAssetPath = const Value.absent(),
                Value<int?> northExitId = const Value.absent(),
                Value<int?> southExitId = const Value.absent(),
                Value<int?> eastExitId = const Value.absent(),
                Value<int?> westExitId = const Value.absent(),
                Value<bool> isExplored = const Value.absent(),
              }) => RoomsCompanion.insert(
                id: id,
                act: act,
                title: title,
                description: description,
                imageAssetPath: imageAssetPath,
                northExitId: northExitId,
                southExitId: southExitId,
                eastExitId: eastExitId,
                westExitId: westExitId,
                isExplored: isExplored,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomsTable, RoomData>(table),
                  BaseReferences<_$AppDatabase, $RoomsTable, RoomData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      RoomData,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (RoomData, BaseReferences<_$AppDatabase, $RoomsTable, RoomData>),
      RoomData,
      PrefetchHooks Function()
    >;
typedef $$ItemsTableCreateCompanionBuilder =
    ItemsCompanion Function({
      required String id,
      Value<int?> ownerId,
      Value<int?> groundRoomId,
      required String name,
      required String baseType,
      Value<String> rarity,
      Value<bool> isEquipped,
      Value<String?> equipSlot,
      Value<int> minDamage,
      Value<int> maxDamage,
      Value<int> armorValue,
      Value<int> socketCount,
      Value<String> modifiersJson,
      Value<int> rowid,
    });
typedef $$ItemsTableUpdateCompanionBuilder =
    ItemsCompanion Function({
      Value<String> id,
      Value<int?> ownerId,
      Value<int?> groundRoomId,
      Value<String> name,
      Value<String> baseType,
      Value<String> rarity,
      Value<bool> isEquipped,
      Value<String?> equipSlot,
      Value<int> minDamage,
      Value<int> maxDamage,
      Value<int> armorValue,
      Value<int> socketCount,
      Value<String> modifiersJson,
      Value<int> rowid,
    });

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groundRoomId => $composableBuilder(
    column: $table.groundRoomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseType => $composableBuilder(
    column: $table.baseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipSlot => $composableBuilder(
    column: $table.equipSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minDamage => $composableBuilder(
    column: $table.minDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxDamage => $composableBuilder(
    column: $table.maxDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get armorValue => $composableBuilder(
    column: $table.armorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get socketCount => $composableBuilder(
    column: $table.socketCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modifiersJson => $composableBuilder(
    column: $table.modifiersJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groundRoomId => $composableBuilder(
    column: $table.groundRoomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseType => $composableBuilder(
    column: $table.baseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipSlot => $composableBuilder(
    column: $table.equipSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minDamage => $composableBuilder(
    column: $table.minDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxDamage => $composableBuilder(
    column: $table.maxDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get armorValue => $composableBuilder(
    column: $table.armorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get socketCount => $composableBuilder(
    column: $table.socketCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modifiersJson => $composableBuilder(
    column: $table.modifiersJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<int> get groundRoomId => $composableBuilder(
    column: $table.groundRoomId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get baseType =>
      $composableBuilder(column: $table.baseType, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipSlot =>
      $composableBuilder(column: $table.equipSlot, builder: (column) => column);

  GeneratedColumn<int> get minDamage =>
      $composableBuilder(column: $table.minDamage, builder: (column) => column);

  GeneratedColumn<int> get maxDamage =>
      $composableBuilder(column: $table.maxDamage, builder: (column) => column);

  GeneratedColumn<int> get armorValue => $composableBuilder(
    column: $table.armorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get socketCount => $composableBuilder(
    column: $table.socketCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modifiersJson => $composableBuilder(
    column: $table.modifiersJson,
    builder: (column) => column,
  );
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemsTable,
          ItemData,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (ItemData, BaseReferences<_$AppDatabase, $ItemsTable, ItemData>),
          ItemData,
          PrefetchHooks Function()
        > {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int?> ownerId = const Value.absent(),
                Value<int?> groundRoomId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> baseType = const Value.absent(),
                Value<String> rarity = const Value.absent(),
                Value<bool> isEquipped = const Value.absent(),
                Value<String?> equipSlot = const Value.absent(),
                Value<int> minDamage = const Value.absent(),
                Value<int> maxDamage = const Value.absent(),
                Value<int> armorValue = const Value.absent(),
                Value<int> socketCount = const Value.absent(),
                Value<String> modifiersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion(
                id: id,
                ownerId: ownerId,
                groundRoomId: groundRoomId,
                name: name,
                baseType: baseType,
                rarity: rarity,
                isEquipped: isEquipped,
                equipSlot: equipSlot,
                minDamage: minDamage,
                maxDamage: maxDamage,
                armorValue: armorValue,
                socketCount: socketCount,
                modifiersJson: modifiersJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int?> ownerId = const Value.absent(),
                Value<int?> groundRoomId = const Value.absent(),
                required String name,
                required String baseType,
                Value<String> rarity = const Value.absent(),
                Value<bool> isEquipped = const Value.absent(),
                Value<String?> equipSlot = const Value.absent(),
                Value<int> minDamage = const Value.absent(),
                Value<int> maxDamage = const Value.absent(),
                Value<int> armorValue = const Value.absent(),
                Value<int> socketCount = const Value.absent(),
                Value<String> modifiersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemsCompanion.insert(
                id: id,
                ownerId: ownerId,
                groundRoomId: groundRoomId,
                name: name,
                baseType: baseType,
                rarity: rarity,
                isEquipped: isEquipped,
                equipSlot: equipSlot,
                minDamage: minDamage,
                maxDamage: maxDamage,
                armorValue: armorValue,
                socketCount: socketCount,
                modifiersJson: modifiersJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, ItemData>(table),
                  BaseReferences<_$AppDatabase, $ItemsTable, ItemData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemsTable,
      ItemData,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (ItemData, BaseReferences<_$AppDatabase, $ItemsTable, ItemData>),
      ItemData,
      PrefetchHooks Function()
    >;
typedef $$MobsTableCreateCompanionBuilder =
    MobsCompanion Function({
      Value<int> id,
      required int roomId,
      required String name,
      required int level,
      required int maxHp,
      required int currentHp,
      required int minDamage,
      required int maxDamage,
      Value<int> armor,
      required int expReward,
      Value<bool> isAlive,
      Value<String> dropTableJson,
    });
typedef $$MobsTableUpdateCompanionBuilder =
    MobsCompanion Function({
      Value<int> id,
      Value<int> roomId,
      Value<String> name,
      Value<int> level,
      Value<int> maxHp,
      Value<int> currentHp,
      Value<int> minDamage,
      Value<int> maxDamage,
      Value<int> armor,
      Value<int> expReward,
      Value<bool> isAlive,
      Value<String> dropTableJson,
    });

class $$MobsTableFilterComposer extends Composer<_$AppDatabase, $MobsTable> {
  $$MobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minDamage => $composableBuilder(
    column: $table.minDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxDamage => $composableBuilder(
    column: $table.maxDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get armor => $composableBuilder(
    column: $table.armor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expReward => $composableBuilder(
    column: $table.expReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAlive => $composableBuilder(
    column: $table.isAlive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dropTableJson => $composableBuilder(
    column: $table.dropTableJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MobsTableOrderingComposer extends Composer<_$AppDatabase, $MobsTable> {
  $$MobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minDamage => $composableBuilder(
    column: $table.minDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxDamage => $composableBuilder(
    column: $table.maxDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get armor => $composableBuilder(
    column: $table.armor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expReward => $composableBuilder(
    column: $table.expReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAlive => $composableBuilder(
    column: $table.isAlive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dropTableJson => $composableBuilder(
    column: $table.dropTableJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MobsTable> {
  $$MobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get maxHp =>
      $composableBuilder(column: $table.maxHp, builder: (column) => column);

  GeneratedColumn<int> get currentHp =>
      $composableBuilder(column: $table.currentHp, builder: (column) => column);

  GeneratedColumn<int> get minDamage =>
      $composableBuilder(column: $table.minDamage, builder: (column) => column);

  GeneratedColumn<int> get maxDamage =>
      $composableBuilder(column: $table.maxDamage, builder: (column) => column);

  GeneratedColumn<int> get armor =>
      $composableBuilder(column: $table.armor, builder: (column) => column);

  GeneratedColumn<int> get expReward =>
      $composableBuilder(column: $table.expReward, builder: (column) => column);

  GeneratedColumn<bool> get isAlive =>
      $composableBuilder(column: $table.isAlive, builder: (column) => column);

  GeneratedColumn<String> get dropTableJson => $composableBuilder(
    column: $table.dropTableJson,
    builder: (column) => column,
  );
}

class $$MobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MobsTable,
          MobData,
          $$MobsTableFilterComposer,
          $$MobsTableOrderingComposer,
          $$MobsTableAnnotationComposer,
          $$MobsTableCreateCompanionBuilder,
          $$MobsTableUpdateCompanionBuilder,
          (MobData, BaseReferences<_$AppDatabase, $MobsTable, MobData>),
          MobData,
          PrefetchHooks Function()
        > {
  $$MobsTableTableManager(_$AppDatabase db, $MobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roomId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> maxHp = const Value.absent(),
                Value<int> currentHp = const Value.absent(),
                Value<int> minDamage = const Value.absent(),
                Value<int> maxDamage = const Value.absent(),
                Value<int> armor = const Value.absent(),
                Value<int> expReward = const Value.absent(),
                Value<bool> isAlive = const Value.absent(),
                Value<String> dropTableJson = const Value.absent(),
              }) => MobsCompanion(
                id: id,
                roomId: roomId,
                name: name,
                level: level,
                maxHp: maxHp,
                currentHp: currentHp,
                minDamage: minDamage,
                maxDamage: maxDamage,
                armor: armor,
                expReward: expReward,
                isAlive: isAlive,
                dropTableJson: dropTableJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roomId,
                required String name,
                required int level,
                required int maxHp,
                required int currentHp,
                required int minDamage,
                required int maxDamage,
                Value<int> armor = const Value.absent(),
                required int expReward,
                Value<bool> isAlive = const Value.absent(),
                Value<String> dropTableJson = const Value.absent(),
              }) => MobsCompanion.insert(
                id: id,
                roomId: roomId,
                name: name,
                level: level,
                maxHp: maxHp,
                currentHp: currentHp,
                minDamage: minDamage,
                maxDamage: maxDamage,
                armor: armor,
                expReward: expReward,
                isAlive: isAlive,
                dropTableJson: dropTableJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MobsTable, MobData>(table),
                  BaseReferences<_$AppDatabase, $MobsTable, MobData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MobsTable,
      MobData,
      $$MobsTableFilterComposer,
      $$MobsTableOrderingComposer,
      $$MobsTableAnnotationComposer,
      $$MobsTableCreateCompanionBuilder,
      $$MobsTableUpdateCompanionBuilder,
      (MobData, BaseReferences<_$AppDatabase, $MobsTable, MobData>),
      MobData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$MobsTableTableManager get mobs => $$MobsTableTableManager(_db, _db.mobs);
}
