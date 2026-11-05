import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fabula_tcg_app/core/errors/exceptions.dart';
import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/base_state.dart';
import 'package:fabula_tcg_app/domain/entities/territory_state.dart';

/// Riverpod notifier that manages a player's territory zone,
/// enforcing Fábula TCG base and territory rules.
///
/// Rules implemented:
/// - 4 Surroundings (5 resistance) + 1 Center (15 resistance) (Rule 3.1.7–3.1.8).
/// - Persistent damage across turns (Section 4.2).
/// - Destruction when resistance ≤ 0 (Section 4.2).
/// - Influence conquest formula: attacker > blocker + resistance (Rule 1.22.5a).
/// - Center exposed only when ALL 4 original surroundings are gone (Rule 3.1.11).
/// - Center cannot be attacked/influenced while protected (Rule 3.1.9).
/// - Victory immediately when Center is destroyed or conquered.
class TerritoryNotifier extends StateNotifier<TerritoryState> {
  /// Creates a [TerritoryNotifier] for [playerId] with initial territory.
  TerritoryNotifier(PlayerId playerId)
      : super(TerritoryState.initial(playerId));

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Applies [damageAmount] to the base identified by [baseId].
  ///
  /// If resistance drops to ≤ 0, the base is marked as destroyed.
  /// Throws [GameRuleException] if the base is already destroyed.
  void applyDamage(String baseId, int damageAmount) {
    if (damageAmount <= 0) {
      throw const GameRuleException(
        'Damage amount must be positive',
        ruleReference: '1.8.1',
      );
    }

    final index = _requireBaseIndex(baseId);
    final base = state.bases[index];

    if (base.isDestroyed) {
      throw GameRuleException(
        'Cannot apply damage to a destroyed base ($baseId)',
      );
    }

    final newResistance = base.currentResistance - damageAmount;
    final isDestroyed = newResistance <= 0;
    final updated = base.copyWith(
      currentResistance: isDestroyed ? 0 : newResistance,
      isDestroyed: isDestroyed,
    );

    _updateBase(index, updated);
  }

  /// Resolves an influence contest on [baseId].
  ///
  /// Conquest formula (Rule 1.22.5a):
  ///   attackerInfluence > blockerInfluence + currentResistance
  ///
  /// If satisfied, control transfers to [conqueror].
  /// Throws [GameRuleException] if the base cannot be targeted (Center locked).
  void resolveInfluenceContest({
    required String baseId,
    required int attackerInfluence,
    required int blockerInfluence,
    required PlayerId conqueror,
  }) {
    if (attackerInfluence < 0 || blockerInfluence < 0) {
      throw const GameRuleException(
        'Influence values must be non-negative',
        ruleReference: '1.8.1',
      );
    }

    final index = _requireBaseIndex(baseId);
    final base = state.bases[index];

    _validateAttackTarget(base);

    // Rule 1.22.5a: strictly greater than, equality does NOT conquer.
    final conquers =
        attackerInfluence > blockerInfluence + base.currentResistance;
    if (!conquers) return; // No conquest, no state change.

    final updated = base.copyWith(currentController: conqueror);
    _updateBase(index, updated);
  }

  /// Validates whether a base can currently be attacked or influenced.
  ///
  /// Throws [GameRuleException] if the Center is targeted while protected.
  void validateAttackTarget(String baseId) {
    final index = _requireBaseIndex(baseId);
    _validateAttackTarget(state.bases[index]);
  }

  /// Resets all bases to initial state (new match).
  void resetTerritory() {
    state = TerritoryState.initial(state.playerId);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  int _requireBaseIndex(String baseId) {
    final index = state.bases.indexWhere((b) => b.id == baseId);
    if (index == -1) {
      throw GameRuleException('Base not found: $baseId');
    }
    return index;
  }

  void _validateAttackTarget(BaseState base) {
    if (base.isDestroyed) {
      throw GameRuleException(
        'Cannot target a destroyed base (${base.id})',
      );
    }
    // Prevent targeting Center while it is protected.
    if (base.type == BaseType.center && !state.isCenterExposed) {
      throw const GameRuleException(
        'Center cannot be attacked or influenced while protected by surroundings',
        ruleReference: '3.1.9',
      );
    }
  }

  void _updateBase(int index, BaseState updated) {
    final newBases = List<BaseState>.from(state.bases);
    newBases[index] = updated;
    state = state.copyWith(bases: newBases);
  }
}
