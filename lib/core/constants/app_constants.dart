/// Application-wide constants for the Fábula TCG companion app.
abstract final class AppConstants {
  /// Maximum number of resources a player can have.
  static const int maxResourceCap = 10;

  /// Resources gained on the first turn.
  static const int initialMaxResources = 2;

  /// Resource increment per turn.
  static const int resourceIncrementPerTurn = 2;

  /// Default resistance for surrounding bases.
  static const int surroundingsResistance = 5;

  /// Default resistance for the center base.
  static const int centerResistance = 15;

  /// Number of surrounding bases per player.
  static const int surroundingsCount = 4;

  /// Maximum hand size at end of turn.
  static const int maxHandSize = 5;

  /// Initial hand size at match start.
  static const int initialHandSize = 6;
}
