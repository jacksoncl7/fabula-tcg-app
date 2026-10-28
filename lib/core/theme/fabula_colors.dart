import 'package:flutter/material.dart';

/// Official color palette tokens for Fábula TCG.
///
/// Direct mapping to the official 7 identities of cards and bases.
abstract final class FabulaColors {
  /// White: Primary buttons, neutral counters, and active selection borders.
  static const Color white = Color(0xFFF8F9FA);

  /// Blue: Turn phase indicators, stats headers, navigation.
  static const Color blue = Color(0xFF1976D2);

  /// Yellow: Resource counter highlights, priority tokens.
  static const Color yellow = Color(0xFFFBC02D);

  /// Green: Life points, restoration indicators, ally health.
  static const Color green = Color(0xFF388E3C);

  /// Red: Damage buttons, destruction, offensive sub-phase alerts.
  static const Color red = Color(0xFFD32F2F);

  /// Purple: Influence sub-phase markers, control shift, special states.
  static const Color purple = Color(0xFF7B1FA2);

  /// Colorless: Backgrounds, neutral dividers, disabled elements.
  static const Color colorless = Color(0xFF757575);

  /// Background surface dark
  static const Color surfaceDark = Color(0xFF121212);

  /// Background surface light
  static const Color surfaceLight = Color(0xFFF4F6F8);
}
