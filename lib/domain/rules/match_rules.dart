import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/match_state.dart';
import 'package:fabula_tcg_app/domain/rules/resource_rules.dart';
import 'package:fabula_tcg_app/domain/rules/territory_rules.dart';

/// Manages the match round and turn alternation between players.
///
/// Rules implemented:
/// - Match starts at Turn 1 with Player 1 active.
/// - When active player passes turn:
///   - If Player 1 was active, active player becomes Player 2.
///     If Player 2 has not had their first active turn yet, Player 2 plays turn 1 (or restores).
///     If Player 2 already played turn 1, Player 2 advances to next turn (+2 max).
///   - If Player 2 was active, match turn advances (+1), active player becomes Player 1,
///     and Player 1 advances to next turn (+2 max, restored).
/// - Unspent resources from the inactive player remain available for Maneuvers (Rule 1.7.3).
/// - Reset restores all resources, territories, and match state back to Turn 1 with Player 1 active.
class MatchNotifier extends StateNotifier<MatchState> {
  MatchNotifier({
    PlayerId initialActivePlayer = const PlayerId('player_1'),
  }) : super(
          MatchState(
            turnNumber: 1,
            activePlayer: initialActivePlayer,
          ),
        );

  /// Advances the match to the next player's turn.
  ///
  /// Applies Fábula TCG active turn progression to the incoming active player:
  /// - Passing from Player 1 to Player 2:
  ///   - If Turn 1 and P2 hasn't taken their active turn yet: P2 plays their Turn 1 (keeps/restores initial resources).
  ///   - Otherwise: P2 advances to their next active turn (+2 max resources, restored).
  /// - Passing from Player 2 to Player 1:
  ///   - Match turnNumber increments by 1.
  ///   - P1 advances to their next active turn (+2 max resources, restored).
  void advanceTurn({
    required ResourceNotifier p1Resource,
    required ResourceNotifier p2Resource,
  }) {
    if (state.activePlayer == const PlayerId('player_1')) {
      final isP2FirstTurn =
          p2Resource.state.turnNumber == 1 && state.turnNumber == 1;
      if (!isP2FirstTurn) {
        p2Resource.advanceToNextTurn();
      } else {
        p2Resource.restore();
      }
      state = state.copyWith(activePlayer: const PlayerId('player_2'));
    } else {
      final nextMatchTurn = state.turnNumber + 1;
      p1Resource.advanceToNextTurn();
      state = state.copyWith(
        turnNumber: nextMatchTurn,
        activePlayer: const PlayerId('player_1'),
      );
    }
  }

  /// Resets the full match (resources, territories, and match turn) to initial state.
  void resetMatch({
    required ResourceNotifier p1Resource,
    required ResourceNotifier p2Resource,
    required TerritoryNotifier p1Territory,
    required TerritoryNotifier p2Territory,
  }) {
    p1Resource.reset();
    p2Resource.reset();
    p1Territory.resetTerritory();
    p2Territory.resetTerritory();
    state = const MatchState(
      turnNumber: 1,
      activePlayer: PlayerId('player_1'),
    );
  }
}
