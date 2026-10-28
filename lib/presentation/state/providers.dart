import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fabula_tcg_app/core/utils/player_id.dart';
import 'package:fabula_tcg_app/domain/entities/resource_state.dart';
import 'package:fabula_tcg_app/domain/rules/resource_rules.dart';

/// Provider for Player 1's resource notifier.
final player1ResourceProvider =
    StateNotifierProvider<ResourceNotifier, ResourceState>(
  (ref) => ResourceNotifier(const PlayerId('player_1')),
);

/// Provider for Player 2's resource notifier.
final player2ResourceProvider =
    StateNotifierProvider<ResourceNotifier, ResourceState>(
  (ref) => ResourceNotifier(const PlayerId('player_2')),
);
