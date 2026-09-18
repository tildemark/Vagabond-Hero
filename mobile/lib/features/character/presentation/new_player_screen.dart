import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vagabond_hero/core/database/app_database.dart';
import 'package:vagabond_hero/core/database/database_providers.dart';
import 'package:vagabond_hero/core/theme/game_colors.dart';
import 'package:vagabond_hero/features/navigation/presentation/game_screen.dart';

class NewPlayerScreen extends ConsumerStatefulWidget {
  const NewPlayerScreen({super.key});

  @override
  ConsumerState<NewPlayerScreen> createState() => _NewPlayerScreenState();
}

class _NewPlayerScreenState extends ConsumerState<NewPlayerScreen> {
  final _nameController = TextEditingController(text: 'Wanderer');
  String _selectedClass = 'Vagabond';
  bool _isSubmitting = false;

  // Archetype presets
  final Map<String, ({String icon, String title, String subtitle, Color color, String resource, String trait, Map<String, int> stats, String lore})> _archetypes = {
    'Vagabond': (
      icon: '??',
      title: 'Vagabond',
      subtitle: 'Universal Survivor • Tier 1',
      color: const Color(0xFFF59E0B),
      resource: 'Grit (0–100)',
      trait: 'Emergency Triage & Relic Luck',
      stats: {'STR': 10, 'AGI': 10, 'INT': 10, 'STA': 10},
      lore: 'Stripped of memories and divine favor, the Vagabond survives on raw adaptability, scavenging scraps, and emergency triage in hostile territory.',
    ),
    'Juggernaut': (
      icon: '???',
      title: 'Juggernaut',
      subtitle: 'Heavy Vanguard • High Strength',
      color: const Color(0xFFEF4444),
      resource: 'Fury (0–100)',
      trait: 'Unstoppable Cleaves & Taunt',
      stats: {'STR': 15, 'AGI': 8, 'INT': 7, 'STA': 14},
      lore: 'An armored colossus that converts pain directly into wrath. Commands heavy plate, massive shields, and devastating armor-shredding blows.',
    ),
    'Phantom': (
      icon: '?',
      title: 'Phantom',
      subtitle: 'Void Assassin • High Agility',
      color: const Color(0xFFFACC15),
      resource: 'Energy (0–100)',
      trait: 'Extreme Evasion & Lethal Neurotoxin',
      stats: {'STR': 8, 'AGI': 16, 'INT': 8, 'STA': 8},
      lore: 'Stalker of fractured shadows. Moves like lightning, slips past enemy strikes with untouchable Evasion, and executes rapid multi-hit combos.',
    ),
    'Weaver': (
      icon: '??',
      title: 'Weaver',
      subtitle: 'Arcane Master • High Intelligence',
      color: const Color(0xFF38BDF8),
      resource: 'Mana (Deep Pool)',
      trait: '100% Accurate Spells & Void Barrier',
      stats: {'STR': 6, 'AGI': 8, 'INT': 16, 'STA': 10},
      lore: 'Manipulator of cosmic entropy and astral threads. Never misses with homing arcane blasts, shields life with void barriers, and unleashes elemental storms.',
    ),
    'Warden': (
      icon: '??',
      title: 'Warden',
      subtitle: 'Beast Master • Hybrid Stamina',
      color: const Color(0xFF10B981),
      resource: 'Animus (0–100)',
      trait: 'Autonomous Pet Combat & Life Leech',
      stats: {'STR': 11, 'AGI': 8, 'INT': 11, 'STA': 14},
      lore: 'Commands beast companions and ancient nature occult bonds. Transfers debuffs onto companions and siphons enemy vitality through thorny roots.',
    ),
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _startAdventure() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a wanderer name.'),
          backgroundColor: GameColors.crimsonBlood,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.heavyImpact();

    try {
      final db = ref.read(databaseProvider);
      final arch = _archetypes[_selectedClass]!;
      final stats = arch.stats;

      // 1. Reset/Upsert Player (ID 1)
      final existingPlayer = await (db.select(db.players)..where((t) => t.id.equals(1))).getSingleOrNull();

      final baseHp = 40 + (stats['STA']! * 2);
      final playerCompanion = PlayersCompanion(
        name: Value(name),
        jobClass: Value(_selectedClass),
        level: const Value(1),
        currentExp: const Value(0),
        maxExp: const Value(100),
        baseHp: Value(baseHp),
        currentHp: Value(baseHp),
        strength: Value(stats['STR']!),
        agility: Value(stats['AGI']!),
        intelligence: Value(stats['INT']!),
        stamina: Value(stats['STA']!),
        currentRoomId: const Value(101),
        silverPrisms: const Value(25),
      );

      if (existingPlayer != null) {
        await (db.update(db.players)..where((t) => t.id.equals(1))).write(playerCompanion);
      } else {
        await db.into(db.players).insert(playerCompanion);
      }

      // 2. Reset room explored status to beginning
      await db.update(db.rooms).write(
        const RoomsCompanion(isExplored: Value(false)),
      );
      await (db.update(db.rooms)..where((t) => t.id.equals(101))).write(
        const RoomsCompanion(isExplored: Value(true)),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize hero: $e'),
          backgroundColor: GameColors.crimsonBlood,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeArch = _archetypes[_selectedClass]!;

    return Scaffold(
      backgroundColor: GameColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: GameColors.bgSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: GameColors.cyanRune),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AWAKEN NEW WANDERER',
          style: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: GameColors.borderSubtle, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Terminal intro header
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: GameColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: GameColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Text('?', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INITIATING RE-MATERIALIZATION',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: GameColors.cyanRune,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Enter your true name and choose your soul archetype to awaken in Node 101.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: GameColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Hero Name input
              Text(
                'WANDERER DESIGNATION',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: GameColors.goldAccent,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                maxLength: 24,
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: GameColors.bgSurface,
                  prefixIcon: const Icon(Icons.person_outline, color: GameColors.cyanRune),
                  hintText: 'Enter character name...',
                  hintStyle: GoogleFonts.cinzel(color: GameColors.textDim),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: GameColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: GameColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: GameColors.cyanRune, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Class Archetype Selection
              Text(
                'STARTING ARCHETYPE',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: GameColors.goldAccent,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),

              // Archetype horizontal selector deck
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _archetypes.entries.map((entry) {
                    final isSelected = entry.key == _selectedClass;
                    final data = entry.value;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedClass = entry.key);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? data.color.withValues(alpha: 0.15) : GameColors.bgSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? data.color : GameColors.borderSubtle,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(data.icon, style: const TextStyle(fontSize: 18)),
                                const Spacer(),
                                if (isSelected)
                                  Icon(Icons.check_circle, color: data.color, size: 14),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data.title,
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : GameColors.textMain,
                              ),
                            ),
                            Text(
                              data.subtitle.split('•').first.trim(),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                color: data.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 18),

              // Selected Archetype Deep Dossier
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GameColors.bgSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: activeArch.color.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(activeArch.icon, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeArch.title,
                                style: GoogleFonts.cinzel(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                activeArch.subtitle,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10.5,
                                  color: activeArch.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      activeArch.lore,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: GameColors.textMain,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: GameColors.borderSubtle, height: 1),
                    const SizedBox(height: 14),

                    // Resource & Unique Trait
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RESOURCE ENGINE',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 9.5,
                                  color: GameColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activeArch.resource,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: activeArch.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TACTICAL TRAIT',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 9.5,
                                  color: GameColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activeArch.trait,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Initial Attribute Distribution
                    Text(
                      'STARTING ATTRIBUTE MATRIX',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        color: GameColors.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: activeArch.stats.entries.map((stat) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: GameColors.bgSecondary,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: GameColors.borderSubtle),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  stat.key,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9.5,
                                    color: GameColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${stat.value}',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: stat.value > 12 ? activeArch.color : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Embark Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _startAdventure,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeArch.color,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.flash_on, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'AWAKEN IN THE ASH',
                              style: GoogleFonts.cinzel(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
