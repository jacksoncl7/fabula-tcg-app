import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/core/errors/exceptions.dart';
import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/base_state.dart';
import 'package:fabula_tcg_app/domain/entities/territory_state.dart';
import 'package:fabula_tcg_app/domain/rules/territory_rules.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _p1 = PlayerId('player_1');
const _p2 = PlayerId('player_2');

extension on TerritoryNotifier {
  /// Adds an empty listener so StateNotifier is considered mounted.
  void _mount() => addListener((_) {}, fireImmediately: false);
}

TerritoryNotifier _mounted([PlayerId id = _p1]) {
  final n = TerritoryNotifier(id);
  n._mount();
  return n;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('TerritoryState.initial', () {
    test('creates 4 surroundings with 5 resistance', () {
      final t = TerritoryState.initial(_p1);
      final surr = t.surroundings;
      expect(surr.length, 4);
      for (final b in surr) {
        expect(b.maxResistance, kSurroundingResistance);
        expect(b.currentResistance, kSurroundingResistance);
        expect(b.isDestroyed, false);
        expect(b.originalOwner, _p1);
        expect(b.currentController, _p1);
      }
    });

    test('creates 1 center with 15 resistance', () {
      final t = TerritoryState.initial(_p1);
      final c = t.center;
      expect(c.maxResistance, kCenterResistance);
      expect(c.currentResistance, kCenterResistance);
      expect(c.type, BaseType.center);
      expect(c.isDestroyed, false);
    });

    test('center is NOT exposed on fresh territory', () {
      final t = TerritoryState.initial(_p1);
      expect(t.isCenterExposed, false);
    });

    test('center is NOT lost on fresh territory', () {
      final t = TerritoryState.initial(_p1);
      expect(t.isCenterLost, false);
    });
  });

  // -------------------------------------------------------------------------
  group('TerritoryNotifier.applyDamage', () {
    test('reduces resistance by damage amount', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      n.applyDamage(baseId, 2);
      expect(
          n.state.bases.firstWhere((b) => b.id == baseId).currentResistance, 3);
    });

    test('damage is persistent (multiple calls accumulate)', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      n.applyDamage(baseId, 2);
      n.applyDamage(baseId, 2);
      expect(
          n.state.bases.firstWhere((b) => b.id == baseId).currentResistance, 1);
    });

    test('base is destroyed when resistance reaches zero', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      n.applyDamage(baseId, 5);
      final base = n.state.bases.firstWhere((b) => b.id == baseId);
      expect(base.isDestroyed, true);
      expect(base.currentResistance, 0);
    });

    test('base is destroyed when overkill damage is applied', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      n.applyDamage(baseId, 99);
      final base = n.state.bases.firstWhere((b) => b.id == baseId);
      expect(base.isDestroyed, true);
      expect(base.currentResistance, 0);
    });

    test('throws GameRuleException on non-positive damage', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      expect(() => n.applyDamage(baseId, 0), throwsA(isA<GameRuleException>()));
      expect(
          () => n.applyDamage(baseId, -1), throwsA(isA<GameRuleException>()));
    });

    test('throws GameRuleException when damaging a destroyed base', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      n.applyDamage(baseId, 5); // destroy it
      expect(() => n.applyDamage(baseId, 1), throwsA(isA<GameRuleException>()));
    });

    test('throws GameRuleException for unknown baseId', () {
      final n = _mounted();
      expect(() => n.applyDamage('unknown_base', 1),
          throwsA(isA<GameRuleException>()));
    });
  });

  // -------------------------------------------------------------------------
  group('TerritoryState.isCenterExposed (Exposed Center Rule 3.1.9–3.1.11)',
      () {
    test('center becomes exposed only when ALL 4 surroundings are gone', () {
      final n = _mounted();
      final surroundingIds = n.state.surroundings.map((b) => b.id).toList();

      // Destroy 3 surroundings — center still protected
      for (var i = 0; i < 3; i++) {
        n.applyDamage(surroundingIds[i], kSurroundingResistance);
      }
      expect(n.state.isCenterExposed, false);

      // Destroy 4th — now exposed
      n.applyDamage(surroundingIds[3], kSurroundingResistance);
      expect(n.state.isCenterExposed, true);
    });

    test('conquered opponent surroundings do NOT protect own center', () {
      // Player 1's territory; simulate a base originally owned by p1
      // being conquered by p2 (currentController = p2).
      final t = TerritoryState.initial(_p1);

      // Transfer control of all 4 surroundings to p2 (via copyWith).
      final updatedBases = t.bases.map((b) {
        if (b.type == BaseType.surroundings) {
          return b.copyWith(currentController: _p2);
        }
        return b;
      }).toList();

      final updatedT = t.copyWith(bases: updatedBases);
      // All original surroundings are now controlled by opponent → exposed.
      expect(updatedT.isCenterExposed, true);
    });

    test('center exposure reverts when player regains control of a surrounding',
        () {
      // Start from fully-exposed territory.
      final t = TerritoryState.initial(_p1);
      var updatedBases = t.bases.map((b) {
        if (b.type == BaseType.surroundings) {
          return b.copyWith(currentController: _p2);
        }
        return b;
      }).toList();
      var updatedT = t.copyWith(bases: updatedBases);
      expect(updatedT.isCenterExposed, true);

      // Regain control of one surrounding → no longer exposed.
      final regainedId = updatedT.surroundings.first.id;
      updatedBases = updatedT.bases.map((b) {
        if (b.id == regainedId) return b.copyWith(currentController: _p1);
        return b;
      }).toList();
      updatedT = updatedT.copyWith(bases: updatedBases);
      expect(updatedT.isCenterExposed, false);
    });
  });

  // -------------------------------------------------------------------------
  group('TerritoryNotifier.validateAttackTarget', () {
    test(
        'throws GameRuleException when targeting center while surroundings exist',
        () {
      final n = _mounted();
      final centerId = n.state.center.id;
      expect(() => n.validateAttackTarget(centerId),
          throwsA(isA<GameRuleException>()));
    });

    test('does NOT throw when center is exposed', () {
      final n = _mounted();
      // Destroy all 4 surroundings to expose center.
      for (final b in n.state.surroundings) {
        n.applyDamage(b.id, kSurroundingResistance);
      }
      expect(n.state.isCenterExposed, true);
      expect(() => n.validateAttackTarget(n.state.center.id), returnsNormally);
    });
  });

  // -------------------------------------------------------------------------
  group('TerritoryNotifier.resolveInfluenceContest (Rule 1.22.5a)', () {
    test('equal influence does NOT conquer (strictly greater required)', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      // attacker(5) == blocker(0) + resistance(5) → no conquest
      n.resolveInfluenceContest(
        baseId: baseId,
        attackerInfluence: 5,
        blockerInfluence: 0,
        conqueror: _p2,
      );
      final base = n.state.bases.firstWhere((b) => b.id == baseId);
      expect(base.currentController, _p1); // unchanged
    });

    test('strictly greater attacker conquers the base', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      // attacker(6) > blocker(0) + resistance(5) → conquest
      n.resolveInfluenceContest(
        baseId: baseId,
        attackerInfluence: 6,
        blockerInfluence: 0,
        conqueror: _p2,
      );
      final base = n.state.bases.firstWhere((b) => b.id == baseId);
      expect(base.currentController, _p2);
    });

    test('blocker partially negates attacker influence', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      // attacker(7) > blocker(3) + resistance(5)? → 7 > 8 → false → no conquest
      n.resolveInfluenceContest(
        baseId: baseId,
        attackerInfluence: 7,
        blockerInfluence: 3,
        conqueror: _p2,
      );
      final base = n.state.bases.firstWhere((b) => b.id == baseId);
      expect(base.currentController, _p1);
    });

    test('throws when attempting to influence protected center', () {
      final n = _mounted();
      final centerId = n.state.center.id;
      expect(
        () => n.resolveInfluenceContest(
          baseId: centerId,
          attackerInfluence: 999,
          blockerInfluence: 0,
          conqueror: _p2,
        ),
        throwsA(isA<GameRuleException>()),
      );
    });

    test('conquers center when exposed with sufficient influence', () {
      final n = _mounted();
      // Expose the center by destroying all surroundings.
      for (final b in n.state.surroundings) {
        n.applyDamage(b.id, kSurroundingResistance);
      }
      expect(n.state.isCenterExposed, true);

      final centerId = n.state.center.id;
      // attacker(16) > blocker(0) + resistance(15) → conquest
      n.resolveInfluenceContest(
        baseId: centerId,
        attackerInfluence: 16,
        blockerInfluence: 0,
        conqueror: _p2,
      );
      expect(n.state.isCenterLost, true);
      expect(n.state.center.currentController, _p2);
    });

    test('throws on negative influence values', () {
      final n = _mounted();
      final baseId = n.state.surroundings.first.id;
      expect(
        () => n.resolveInfluenceContest(
          baseId: baseId,
          attackerInfluence: -1,
          blockerInfluence: 0,
          conqueror: _p2,
        ),
        throwsA(isA<GameRuleException>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('Victory condition', () {
    test('isCenterLost is true when center is destroyed', () {
      final n = _mounted();
      for (final b in n.state.surroundings) {
        n.applyDamage(b.id, kSurroundingResistance);
      }
      n.applyDamage(n.state.center.id, kCenterResistance);
      expect(n.state.isCenterLost, true);
      expect(n.state.center.isDestroyed, true);
    });

    test('isCenterLost is true when center is conquered', () {
      final n = _mounted();
      for (final b in n.state.surroundings) {
        n.applyDamage(b.id, kSurroundingResistance);
      }
      n.resolveInfluenceContest(
        baseId: n.state.center.id,
        attackerInfluence: 16,
        blockerInfluence: 0,
        conqueror: _p2,
      );
      expect(n.state.isCenterLost, true);
    });
  });

  // -------------------------------------------------------------------------
  group('BaseState immutability', () {
    test('copyWith produces a new distinct instance', () {
      const base = BaseState(
        id: 'test_base',
        type: BaseType.surroundings,
        originalOwner: _p1,
        currentController: _p1,
        currentResistance: 5,
        maxResistance: 5,
      );
      final copy = base.copyWith(currentResistance: 3);
      expect(copy, isNot(same(base)));
      expect(copy.currentResistance, 3);
      expect(base.currentResistance, 5); // unchanged
    });

    test('equality is value-based', () {
      const a = BaseState(
        id: 'base_1',
        type: BaseType.center,
        originalOwner: _p1,
        currentController: _p1,
        currentResistance: 15,
        maxResistance: 15,
      );
      const b = BaseState(
        id: 'base_1',
        type: BaseType.center,
        originalOwner: _p1,
        currentController: _p1,
        currentResistance: 15,
        maxResistance: 15,
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  // -------------------------------------------------------------------------
  group('TerritoryNotifier.resetTerritory', () {
    test('resets all bases to initial state', () {
      final n = _mounted();
      n.applyDamage(n.state.surroundings.first.id, 3);
      n.resetTerritory();
      expect(n.state, equals(TerritoryState.initial(_p1)));
    });
  });
}
