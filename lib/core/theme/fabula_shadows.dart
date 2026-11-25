import 'package:material_ui/material_ui.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';

/// BoxShadow presets for atmospheric depth and game element glow.
abstract final class FabulaShadows {
  /// Subtle purple ambient glow.
  static List<BoxShadow> get purpleGlow => [
        BoxShadow(
          color: FabulaColors.purple.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Teal eco-tech glow.
  static List<BoxShadow> get tealGlow => [
        BoxShadow(
          color: FabulaColors.teal.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Subtle card elevation shadow.
  static List<BoxShadow> get cardElevation => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Error / danger glow.
  static List<BoxShadow> get dangerGlow => [
        BoxShadow(
          color: FabulaColors.error.withValues(alpha: 0.35),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  /// Warning glow (e.g. exposed center).
  static List<BoxShadow> get warningGlow => [
        BoxShadow(
          color: FabulaColors.warning.withValues(alpha: 0.35),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];
}
