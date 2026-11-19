/// Design tokens for consistent spatial rhythm, elevation, and motion.
abstract final class FabulaTokens {
  // ─── Spacing Scale (4px base unit) ───
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  // ─── Border Radius ───
  static const double radiusSm = 6.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // ─── Elevation ───
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // ─── Animation Durations ───
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // ─── Tabletop Component Sizing ───
  static const double counterButtonSize = 56.0;
  static const double counterButtonSizeLg = 64.0;
  static const double toolbarHeight = 48.0;
  static const double baseTileWidth = 76.0;
  static const double centerTileWidth = 164.0;
}
