import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fabula_tcg_app/core/constants/app_constants.dart';
import 'package:fabula_tcg_app/core/errors/exceptions.dart';
import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/resource_state.dart';

/// Riverpod notifier that manages a player's resource state,
/// enforcing Fábula TCG official resource rules.
///
/// Rules implemented:
/// - Turn 1 = 2 max resources (Rule 1.7.2c).
/// - +2 max per turn up to cap of 10 (Rule 1.18.10).
/// - Restoration resets current to max (Rule 1.7.2b).
/// - Resources are non-negative integers (Rule 1.8.1).
class ResourceNotifier extends StateNotifier<ResourceState> {
  /// Creates a [ResourceNotifier] for the given [playerId],
  /// initialized at turn 1 with [AppConstants.initialMaxResources].
  ResourceNotifier(PlayerId playerId)
      : super(
          ResourceState(
            playerId: playerId,
            currentResources: AppConstants.initialMaxResources,
            maxResources: AppConstants.initialMaxResources,
            turnNumber: 1,
          ),
        );

  /// Spends [amount] resources from the current pool.
  ///
  /// Throws [GameRuleException] if insufficient resources.
  void spendResources(int amount) {
    if (amount <= 0) {
      throw const GameRuleException(
        'Spend amount must be positive',
      );
    }
    if (amount > state.currentResources) {
      throw const GameRuleException(
        'Insufficient resources',
        ruleReference: '1.8.1',
      );
    }
    state = state.copyWith(
      currentResources: state.currentResources - amount,
    );
  }

  /// Adds bonus resources from card effects.
  ///
  /// Current resources can exceed max (card effects override).
  void gainBonusResources(int amount) {
    if (amount <= 0) {
      throw const GameRuleException(
        'Bonus amount must be positive',
      );
    }
    state = state.copyWith(
      currentResources: state.currentResources + amount,
    );
  }

  /// Restores current resources to max for the current turn.
  ///
  /// Implements Restoration Phase (Rule 1.7.2b / 1.18.9).
  void restore() {
    state = state.copyWith(
      currentResources: state.maxResources,
    );
  }

  /// Advances to the next turn, incrementing max resources
  /// by [AppConstants.resourceIncrementPerTurn] up to the cap.
  ///
  /// Also restores current resources to the new max.
  void advanceToNextTurn() {
    final nextTurn = state.turnNumber + 1;
    final newMax = (state.maxResources + AppConstants.resourceIncrementPerTurn)
        .clamp(0, state.resourceCap);
    state = state.copyWith(
      turnNumber: nextTurn,
      maxResources: newMax,
      currentResources: newMax,
    );
  }

  /// Modifies the resource cap (for card effects that alter the limit).
  void modifyResourceCap(int newCap) {
    if (newCap < 0) {
      throw const GameRuleException(
        'Resource cap cannot be negative',
        ruleReference: '1.8.1',
      );
    }
    state = state.copyWith(resourceCap: newCap);
  }
}
