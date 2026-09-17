import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_colors.dart';

ThemeData createGameTheme() {
  final baseTextTheme = Typography.material2021().white;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: GameColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: GameColors.cyanRune,
      secondary: GameColors.goldAccent,
      surface: GameColors.bgSurface,
      error: GameColors.crimsonBlood,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: GameColors.textMain,
    ),
    textTheme: GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: GameColors.goldAccent,
        letterSpacing: 1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        color: GameColors.textMain,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13,
        color: GameColors.textMuted,
        height: 1.5,
      ),
      labelSmall: GoogleFonts.jetBrainsMono(
        fontSize: 11,
        color: GameColors.cyanRune,
        letterSpacing: 1,
      ),
    ),
    cardTheme: CardThemeData(
      color: GameColors.bgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: GameColors.borderSubtle),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GameColors.cyanRune,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
