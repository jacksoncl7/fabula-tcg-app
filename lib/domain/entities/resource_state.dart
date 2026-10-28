import 'package:fabula_tcg_app/core/utils/player_id.dart';

/// Immutable state representing a player's resources in a match.
///
/// Follows Fábula TCG resource rules:
/// - Turn 1 = 2 max resources (Rule 1.7.2c / 1.18.10).
/// - +2 max per turn, capped at [resourceCap] (default 10).
/// - Current resources are non-negative integers (Rule 1.8.1).
class ResourceState {
  /// Creates a [ResourceState].
  const ResourceState({
    required this.playerId,
    required this.currentResources,
    required this.maxResources,
    required this.turnNumber,
    this.resourceCap = 10,
  })  : assert(currentResources >= 0, 'Resources cannot be negative'),
        assert(maxResources >= 0, 'Max resources cannot be negative'),
        assert(turnNumber >= 1, 'Turn number must be at least 1');

  /// The player this state belongs to.
  final PlayerId playerId;

  /// Currently available resources.
  final int currentResources;

  /// Maximum resources for the current turn.
  final int maxResources;

  /// Current turn number for this player.
  final int turnNumber;

  /// Absolute resource cap (default 10, modifiable by card effects).
  final int resourceCap;

  /// Creates a copy of this state with the given fields replaced.
  ResourceState copyWith({
    PlayerId? playerId,
    int? currentResources,
    int? maxResources,
    int? turnNumber,
    int? resourceCap,
  }) {
    return ResourceState(
      playerId: playerId ?? this.playerId,
      currentResources: currentResources ?? this.currentResources,
      maxResources: maxResources ?? this.maxResources,
      turnNumber: turnNumber ?? this.turnNumber,
      resourceCap: resourceCap ?? this.resourceCap,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceState &&
          runtimeType == other.runtimeType &&
          playerId == other.playerId &&
          currentResources == other.currentResources &&
          maxResources == other.maxResources &&
          turnNumber == other.turnNumber &&
          resourceCap == other.resourceCap;

  @override
  int get hashCode => Object.hash(
        playerId,
        currentResources,
        maxResources,
        turnNumber,
        resourceCap,
      );

  @override
  String toString() =>
      'ResourceState(player: $playerId, current: $currentResources, '
      'max: $maxResources, turn: $turnNumber, cap: $resourceCap)';
}
