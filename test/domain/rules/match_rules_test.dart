import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/core/constants/app_constants.dart';
import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/rules/match_rules.dart';
import 'package:fabula_tcg_app/domain/rules/resource_rules.dart';
import 'package:fabula_tcg_app/domain/rules/territory_rules.dart';

const _p1 = PlayerId('player_1');
const _p2 = PlayerId('player_2');

void main() {
  late MatchNotifier matchNotifier;
  late ResourceNotifier p1Resource;
  late ResourceNotifier p2Resource;
  late TerritoryNotifier p1Territory;
  late TerritoryNotifier p2Territory;

  setUp(() {
    matchNotifier = MatchNotifier();
    p1Resource = ResourceNotifier(_p1);
    p2Resource = ResourceNotifier(_p2);
    p1Territory = TerritoryNotifier(_p1);
    p2Territory = TerritoryNotifier(_p2);
  });

  group('MatchNotifier - Initialization', () {
    test('match starts at turn 1 with player 1 as active player', () {
      expect(matchNotifier.state.turnNumber, 1);
      expect(matchNotifier.state.activePlayer, _p1);
    });
  });

  group('MatchNotifier - advanceTurn alternation & progression', () {
    test('passing turn from P1 switches active player to P2 on Turn 1', () {
      matchNotifier.advanceTurn(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
      );

      expect(matchNotifier.state.activePlayer, _p2);
      expect(matchNotifier.state.turnNumber, 1);
      // P2 plays their initial Turn 1 with 2 max and 2 current resources
      expect(p2Resource.state.turnNumber, 1);
      expect(p2Resource.state.maxResources, AppConstants.initialMaxResources);
      expect(
          p2Resource.state.currentResources, AppConstants.initialMaxResources);
    });

    test('passing turn from P2 switches to P1 and increments match turn', () {
      // P1 -> P2
      matchNotifier.advanceTurn(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
      );
      // P2 -> P1 (round 1 completes, round 2 starts)
      matchNotifier.advanceTurn(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
      );

      expect(matchNotifier.state.activePlayer, _p1);
      expect(matchNotifier.state.turnNumber, 2);
      // P1 advances to Turn 2 (4 max, 4 current)
      expect(p1Resource.state.turnNumber, 2);
      expect(p1Resource.state.maxResources, 4);
      expect(p1Resource.state.currentResources, 4);
    });

    test('P2 advances to turn 2 when P1 passes turn on Round 2', () {
      // Round 1: P1 -> P2
      matchNotifier.advanceTurn(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
      );
      // Round 1: P2 -> P1 (Round 2 begins)
      matchNotifier.advanceTurn(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
      );
      // Round 2: P1 -> P2
      matchNotifier.advanceTurn(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
      );

      expect(matchNotifier.state.activePlayer, _p2);
      expect(matchNotifier.state.turnNumber, 2);
      // P2 advances to Turn 2 (4 max, 4 current)
      expect(p2Resource.state.turnNumber, 2);
      expect(p2Resource.state.maxResources, 4);
      expect(p2Resource.state.currentResources, 4);
    });

    test('inactive player retains unspent resources for maneuvers (Rule 1.7.3)',
        () {
      // P1 spends 1 of 2 resources
      p1Resource.spendResources(1);
      expect(p1Resource.state.currentResources, 1);

      // P1 passes turn to P2
      matchNotifier.advanceTurn(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
      );

      // P1's 1 unspent resource remains intact during P2's turn
      expect(p1Resource.state.currentResources, 1);
    });
  });

  group('MatchNotifier - resetMatch', () {
    test('resets match, resources, and territories to fresh initial state', () {
      // Advance several turns and alter state
      matchNotifier.advanceTurn(p1Resource: p1Resource, p2Resource: p2Resource);
      matchNotifier.advanceTurn(p1Resource: p1Resource, p2Resource: p2Resource);
      p1Resource.spendResources(2);
      p2Territory.applyDamage(p2Territory.state.surroundings.first.id, 3);

      expect(matchNotifier.state.turnNumber, 2);
      expect(p1Resource.state.currentResources, 2);
      expect(p2Territory.state.surroundings.first.currentResistance, 2);

      // Perform full match reset
      matchNotifier.resetMatch(
        p1Resource: p1Resource,
        p2Resource: p2Resource,
        p1Territory: p1Territory,
        p2Territory: p2Territory,
      );

      // Match state is reset
      expect(matchNotifier.state.turnNumber, 1);
      expect(matchNotifier.state.activePlayer, _p1);

      // Resources are reset
      expect(p1Resource.state.turnNumber, 1);
      expect(p1Resource.state.maxResources, AppConstants.initialMaxResources);
      expect(
          p1Resource.state.currentResources, AppConstants.initialMaxResources);
      expect(p2Resource.state.turnNumber, 1);
      expect(p2Resource.state.maxResources, AppConstants.initialMaxResources);
      expect(
          p2Resource.state.currentResources, AppConstants.initialMaxResources);

      // Territories are reset
      expect(p2Territory.state.surroundings.first.currentResistance,
          AppConstants.surroundingsResistance);
      expect(p1Territory.state.bases.length, 5);
      expect(p2Territory.state.bases.length, 5);
    });
  });
}
