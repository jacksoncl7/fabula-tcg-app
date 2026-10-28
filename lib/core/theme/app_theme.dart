import 'package:flutter/material.dart';
import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';
import 'package:fabula_tcg_app/core/theme/fabula_typography.dart';

/// Design tokens and theme configuration for Fábula TCG Companion App.
abstract final class AppTheme {
  // Re-export color aliases for backward compatibility
  static const Color fabulaWhite = FabulaColors.white;
  static const Color fabulaBlue = FabulaColors.blue;
  static const Color fabulaYellow = FabulaColors.yellow;
  static const Color fabulaGreen = FabulaColors.green;
  static const Color fabulaRed = FabulaColors.red;
  static const Color fabulaPurple = FabulaColors.purple;
  static const Color fabulaColorless = FabulaColors.colorless;

  /// Standard Light Theme
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: FabulaColors.blue,
        scaffoldBackgroundColor: FabulaColors.surfaceLight,
        textTheme: const TextTheme(
          displayLarge: FabulaTypography.displayScore,
          headlineMedium: FabulaTypography.headlineCounter,
          titleMedium: FabulaTypography.phaseLabel,
          labelLarge: FabulaTypography.actionButton,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      );

  /// Standard Dark Theme
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: FabulaColors.blue,
        scaffoldBackgroundColor: FabulaColors.surfaceDark,
        textTheme: const TextTheme(
          displayLarge: FabulaTypography.displayScore,
          headlineMedium: FabulaTypography.headlineCounter,
          titleMedium: FabulaTypography.phaseLabel,
          labelLarge: FabulaTypography.actionButton,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      );

  /// High-Contrast Table Theme (optimized for tournaments and distant viewing)
  static ThemeData get highContrast => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: FabulaColors.yellow,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: FabulaColors.yellow,
          ),
        ),
      );
}
