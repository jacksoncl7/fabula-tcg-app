import 'package:fabula_tcg_app/core/utils/player_id.dart';

/// The structural type of a territory base.
enum BaseType {
  /// Surrounding base — 4 per player, 5 resistance each.
  surroundings,

  /// Center base — 1 per player, 15 resistance.
  center,
}

/// Immutable state for a single territory base.
///
/// Tracks ownership, resistance, and destruction status following
/// Fábula TCG territory rules (Rules 3.1.7–3.1.11, 1.22.5a).
class BaseState {
  /// Creates a [BaseState].
  const BaseState({
    required this.id,
    required this.type,
    required this.originalOwner,
    required this.currentController,
    required this.currentResistance,
    required this.maxResistance,
    this.isDestroyed = false,
  })  : assert(currentResistance >= 0 || isDestroyed,
            'Resistance cannot be negative unless destroyed'),
        assert(maxResistance > 0, 'Max resistance must be positive');

  /// Unique identifier for this base (e.g. 'p1_surrounding_0', 'p1_center').
  final String id;

  /// Structural type of this base.
  final BaseType type;

  /// The player who originally owned this base at match start.
  final PlayerId originalOwner;

  /// The player currently controlling this base (may differ after conquest).
  final PlayerId currentController;

  /// Current resistance points (persists between turns, Rule 1.22.5a).
  final int currentResistance;

  /// Maximum resistance: 5 for surroundings, 15 for center.
  final int maxResistance;

  /// Whether this base has been destroyed (resistance reached ≤ 0).
  final bool isDestroyed;

  /// Creates a copy with the given fields replaced.
  BaseState copyWith({
    String? id,
    BaseType? type,
    PlayerId? originalOwner,
    PlayerId? currentController,
    int? currentResistance,
    int? maxResistance,
    bool? isDestroyed,
  }) {
    return BaseState(
      id: id ?? this.id,
      type: type ?? this.type,
      originalOwner: originalOwner ?? this.originalOwner,
      currentController: currentController ?? this.currentController,
      currentResistance: currentResistance ?? this.currentResistance,
      maxResistance: maxResistance ?? this.maxResistance,
      isDestroyed: isDestroyed ?? this.isDestroyed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseState &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          originalOwner == other.originalOwner &&
          currentController == other.currentController &&
          currentResistance == other.currentResistance &&
          maxResistance == other.maxResistance &&
          isDestroyed == other.isDestroyed;

  @override
  int get hashCode => Object.hash(
        id,
        type,
        originalOwner,
        currentController,
        currentResistance,
        maxResistance,
        isDestroyed,
      );

  @override
  String toString() =>
      'BaseState(id: $id, type: $type, controller: $currentController, '
      'resistance: $currentResistance/$maxResistance, destroyed: $isDestroyed)';
}
