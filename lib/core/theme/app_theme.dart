import 'package:flutter/material.dart';

/// Design tokens and theme configuration for the Fábula TCG app.
///
/// Colors are mapped from the official Fábula TCG base/card identity colors.
abstract final class AppTheme {
  // ---------------------------------------------------------------------------
  // Official Fábula TCG color palette
  // ---------------------------------------------------------------------------

  /// White — primary buttons, neutral markers, active selection borders.
  static const Color fabulaWhite = Color(0xFFF5F5F5);

  /// Blue — turn phase indicators, stat headers, navigation selections.
  static const Color fabulaBlue = Color(0xFF1565C0);

  /// Yellow — resource counter highlight, turn priority markers.
  static const Color fabulaYellow = Color(0xFFFBC02D);

  /// Green — life indicators, restoration markers, ally health.
  static const Color fabulaGreen = Color(0xFF388E3C);

  /// Red — damage buttons, destruction, offensive sub-phase alerts.
  static const Color fabulaRed = Color(0xFFD32F2F);

  /// Purple — influence sub-phase markers, control change, special states.
  static const Color fabulaPurple = Color(0xFF7B1FA2);

  /// Colorless — neutral backgrounds, dividers, disabled cards.
  static const Color fabulaColorless = Color(0xFF9E9E9E);

  // ---------------------------------------------------------------------------
  // Theme data
  // ---------------------------------------------------------------------------

  /// Light theme for the application.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: fabulaBlue,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      );

  /// Dark theme for the application.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: fabulaBlue,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      );
}
