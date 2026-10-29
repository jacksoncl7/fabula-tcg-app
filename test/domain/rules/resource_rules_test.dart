import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/core/constants/app_constants.dart';
import 'package:fabula_tcg_app/core/errors/exceptions.dart';
import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/resource_state.dart';
import 'package:fabula_tcg_app/domain/rules/resource_rules.dart';

void main() {
  late ResourceNotifier notifier;

  setUp(() {
    notifier = ResourceNotifier(const PlayerId('test_player'));
  });

  group('ResourceNotifier - initialization', () {
    test('turn 1 starts with 2 max and 2 current resources', () {
      expect(notifier.state.turnNumber, 1);
      expect(
        notifier.state.maxResources,
        AppConstants.initialMaxResources,
      );
      expect(
        notifier.state.currentResources,
        AppConstants.initialMaxResources,
      );
      expect(notifier.state.resourceCap, AppConstants.maxResourceCap);
    });
  });

  group('ResourceNotifier - advanceToNextTurn', () {
    test('turn 2 increments to 4 max and restores', () {
      notifier.advanceToNextTurn();
      expect(notifier.state.turnNumber, 2);
      expect(notifier.state.maxResources, 4);
      expect(notifier.state.currentResources, 4);
    });

    test('progression from turn 1 to turn 5 reaches cap of 10', () {
      // T1: 2, T2: 4, T3: 6, T4: 8, T5: 10
      for (var i = 0; i < 4; i++) {
        notifier.advanceToNextTurn();
      }
      expect(notifier.state.turnNumber, 5);
      expect(notifier.state.maxResources, AppConstants.maxResourceCap);
      expect(notifier.state.currentResources, AppConstants.maxResourceCap);
    });

    test('max resources do not exceed cap beyond turn 5', () {
      for (var i = 0; i < 6; i++) {
        notifier.advanceToNextTurn();
      }
      expect(notifier.state.turnNumber, 7);
      expect(notifier.state.maxResources, AppConstants.maxResourceCap);
    });
  });

  group('ResourceNotifier - spendResources', () {
    test('spending reduces current resources', () {
      notifier.spendResources(1);
      expect(notifier.state.currentResources, 1);
    });

    test('spending more than available throws GameRuleException', () {
      expect(
        () => notifier.spendResources(3),
        throwsA(isA<GameRuleException>()),
      );
    });

    test('spending zero or negative throws GameRuleException', () {
      expect(
        () => notifier.spendResources(0),
        throwsA(isA<GameRuleException>()),
      );
      expect(
        () => notifier.spendResources(-1),
        throwsA(isA<GameRuleException>()),
      );
    });

    test('resources never go below zero', () {
      notifier.spendResources(2);
      expect(notifier.state.currentResources, 0);
      expect(
        () => notifier.spendResources(1),
        throwsA(isA<GameRuleException>()),
      );
    });
  });

  group('ResourceNotifier - restore', () {
    test('restore resets current to max', () {
      notifier.spendResources(1);
      expect(notifier.state.currentResources, 1);
      notifier.restore();
      expect(notifier.state.currentResources, notifier.state.maxResources);
    });

    test('restoration phase clears previous remainder and restores new max',
        () {
      // Spend 1 on turn 1 (remaining: 1 out of 2)
      notifier.spendResources(1);
      expect(notifier.state.currentResources, 1);

      // Advance to turn 2 — restores to new max of 4
      notifier.advanceToNextTurn();
      expect(notifier.state.currentResources, 4);
      expect(notifier.state.maxResources, 4);
    });
  });

  group('ResourceNotifier - gainBonusResources', () {
    test('bonus resources add to current', () {
      notifier.gainBonusResources(3);
      expect(notifier.state.currentResources, 5);
    });

    test('bonus with zero or negative throws', () {
      expect(
        () => notifier.gainBonusResources(0),
        throwsA(isA<GameRuleException>()),
      );
    });
  });

  group('ResourceNotifier - modifyResourceCap', () {
    test('modifying cap affects future turns', () {
      notifier.modifyResourceCap(6);
      // Advance turns until we hit the new cap
      for (var i = 0; i < 4; i++) {
        notifier.advanceToNextTurn();
      }
      // Max should be clamped at 6 instead of 10
      expect(notifier.state.maxResources, 6);
    });

    test('negative cap throws GameRuleException', () {
      expect(
        () => notifier.modifyResourceCap(-1),
        throwsA(isA<GameRuleException>()),
      );
    });
  });

  group('ResourceState - immutability', () {
    test('copyWith produces a new instance', () {
      final original = notifier.state;
      final copy = original.copyWith(currentResources: 0);
      expect(copy, isNot(same(original)));
      expect(copy.currentResources, 0);
      expect(original.currentResources, 2);
    });

    test('equality by value', () {
      const state1 = ResourceState(
        playerId: PlayerId('p1'),
        currentResources: 2,
        maxResources: 2,
        turnNumber: 1,
      );
      const state2 = ResourceState(
        playerId: PlayerId('p1'),
        currentResources: 2,
        maxResources: 2,
        turnNumber: 1,
      );
      expect(state1, equals(state2));
    });
  });
}
