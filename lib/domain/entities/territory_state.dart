import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/base_state.dart';

/// Resistance assigned to each surrounding base (Rule 3.1.7).
const int kSurroundingResistance = 5;

/// Resistance assigned to the center base (Rule 3.1.8).
const int kCenterResistance = 15;

/// Number of surrounding bases per player.
const int kSurroundingCount = 4;

/// Immutable state representing a player's full territory zone.
///
/// Tracks all 5 bases (4 surroundings + 1 center) and enforces the
/// Exposed-Center rule (Rules 3.1.7–3.1.11).
class TerritoryState {
  /// Creates a [TerritoryState].
  const TerritoryState({
    required this.playerId,
    required this.bases,
  });

  /// The player who owns this territory.
  final PlayerId playerId;

  /// All bases in this territory (4 surroundings + 1 center).
  final List<BaseState> bases;

  // ---------------------------------------------------------------------------
  // Derived computed properties
  // ---------------------------------------------------------------------------

  /// Returns all surrounding bases.
  List<BaseState> get surroundings =>
      bases.where((b) => b.type == BaseType.surroundings).toList();

  /// Returns the center base.
  BaseState get center => bases.firstWhere((b) => b.type == BaseType.center);

  /// Whether the Center is exposed.
  ///
  /// The Center is exposed **only** when **all 4 original surroundings** are
  /// either destroyed or conquered by the opponent.
  /// Conquered opponent bases do NOT protect the Center (Rule 3.1.11).
  bool get isCenterExposed {
    final originalSurroundings = bases.where(
      (b) => b.type == BaseType.surroundings && b.originalOwner == playerId,
    );
    // Center is exposed when every original surrounding is gone (destroyed or
    // controlled by someone other than the original owner).
    return originalSurroundings.every(
      (b) => b.isDestroyed || b.currentController != playerId,
    );
  }

  /// Whether the match is over for this player (Center destroyed or conquered).
  bool get isCenterLost {
    final c = center;
    return c.isDestroyed || c.currentController != playerId;
  }

  /// Creates a copy of this state replacing [bases].
  TerritoryState copyWith({
    PlayerId? playerId,
    List<BaseState>? bases,
  }) {
    return TerritoryState(
      playerId: playerId ?? this.playerId,
      bases: bases ?? this.bases,
    );
  }

  /// Returns a fresh territory for [playerId] with default resistances.
  factory TerritoryState.initial(PlayerId playerId) {
    final surroundings = List.generate(
      kSurroundingCount,
      (i) => BaseState(
        id: '${playerId.value}_surrounding_$i',
        type: BaseType.surroundings,
        originalOwner: playerId,
        currentController: playerId,
        currentResistance: kSurroundingResistance,
        maxResistance: kSurroundingResistance,
      ),
    );
    final center = BaseState(
      id: '${playerId.value}_center',
      type: BaseType.center,
      originalOwner: playerId,
      currentController: playerId,
      currentResistance: kCenterResistance,
      maxResistance: kCenterResistance,
    );
    return TerritoryState(
      playerId: playerId,
      bases: [...surroundings, center],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TerritoryState &&
          runtimeType == other.runtimeType &&
          playerId == other.playerId &&
          _listEquals(bases, other.bases);

  @override
  int get hashCode => Object.hash(playerId, Object.hashAll(bases));

  @override
  String toString() =>
      'TerritoryState(player: $playerId, exposed: $isCenterExposed, '
      'bases: ${bases.length})';

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
