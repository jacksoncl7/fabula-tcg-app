import 'package:material_ui/material_ui.dart';

import 'package:fabula_tcg_app/core/theme/fabula_colors.dart';

/// Gradient presets extracted directly from fabulatcg.com.br stylesheets.
///
/// Channeling Brasofuturism: solarpunk eco-tech with vibrant natural tones.
abstract final class FabulaGradients {
  /// Nightshade — Brasofuturism signature gradient.
  /// Source: .has-nightshade-gradient-background
  ///         linear-gradient(135deg, #330968, #31cdcf)
  static const LinearGradient nightshade = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF330968), // Deep purple
      Color(0xFF31CDCF), // Cyan teal
    ],
  );

  /// Purple crush — vivid teal-to-purple.
  /// Source: .has-purple-crush-gradient-background
  ///         linear-gradient(135deg, #34e2e4, #4721fb 50%, #ab1dfe)
  static const LinearGradient purpleCrush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF34E2E4), // Bright teal
      Color(0xFF4721FB), // Electric blue-purple
      Color(0xFFAB1DFE), // Vivid magenta-purple
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Golden highlight — warm golden sand gradient.
  /// Source: inline background
  ///         linear-gradient(180deg, #f4bb61 48%, #fdea8e 100%)
  static const LinearGradient golden = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      FabulaColors.yellow, // #f4bb61
      FabulaColors.goldenSand, // #fdea8e
    ],
    stops: [0.48, 1.0],
  );

  /// Midnight — deep navy to bright blue.
  /// Source: .has-midnight-gradient-background
  ///         linear-gradient(135deg, #020381, #2874fc)
  static const LinearGradient midnight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF020381), // Deep indigo
      Color(0xFF2874FC), // Bright blue
    ],
  );

  /// Subdued olive — natural eco-tech feel.
  /// Source: .has-subdued-olive-gradient-background
  ///         linear-gradient(135deg, #fafae1, #67a671)
  static const LinearGradient subduedOlive = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFAFAE1), // Pale yellow
      Color(0xFF67A671), // Olive green
    ],
  );

  /// Primary action / CTA gradient — jungle green to vibrant green.
  static const LinearGradient primaryAction = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      FabulaColors.jungleGreen, // #00473e
      FabulaColors.green, // #1c825b
    ],
  );

  /// Restoration / positive action gradient.
  static const LinearGradient restoration = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      FabulaColors.green, // #1c825b
      FabulaColors.teal, // #31cdcf
    ],
  );

  /// Damage / destructive action gradient.
  static const LinearGradient destructive = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      FabulaColors.terracotta, // #d8613c
      FabulaColors.red, // #cf2e2e
    ],
  );
}
