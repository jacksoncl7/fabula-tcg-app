import 'package:fabula_tcg_app/core/utils/player_id.dart';

/// Immutable state representing the active match turn and current active player.
class MatchState {
  const MatchState({
    required this.turnNumber,
    required this.activePlayer,
  }) : assert(turnNumber >= 1, 'Turn number must be at least 1');

  /// Current match round / turn number (starts at 1).
  final int turnNumber;

  /// Player currently taking their active turn.
  final PlayerId activePlayer;

  MatchState copyWith({
    int? turnNumber,
    PlayerId? activePlayer,
  }) {
    return MatchState(
      turnNumber: turnNumber ?? this.turnNumber,
      activePlayer: activePlayer ?? this.activePlayer,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchState &&
          runtimeType == other.runtimeType &&
          turnNumber == other.turnNumber &&
          activePlayer == other.activePlayer;

  @override
  int get hashCode => Object.hash(turnNumber, activePlayer);

  @override
  String toString() =>
      'MatchState(turnNumber: $turnNumber, activePlayer: $activePlayer)';
}
