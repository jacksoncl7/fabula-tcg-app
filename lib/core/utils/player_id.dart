/// Immutable value object representing a player's unique identifier.
class PlayerId {
  /// Creates a [PlayerId] with the given [value].
  const PlayerId(this.value);

  /// The underlying identifier value.
  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PlayerId($value)';
}
