/// Custom exception for game rule violations in Fábula TCG.
///
/// Thrown when an action violates an official game rule, ensuring
/// strict compliance with the rulebook.
class GameRuleException implements Exception {
  /// Creates a [GameRuleException] with the given [message] and
  /// optional [ruleReference] (e.g., '1.7.2c').
  const GameRuleException(this.message, {this.ruleReference});

  /// Human-readable description of the rule violation.
  final String message;

  /// Optional official rule number reference (e.g., '1.7.2c').
  final String? ruleReference;

  @override
  String toString() {
    final ref = ruleReference != null ? ' [Rule $ruleReference]' : '';
    return 'GameRuleException: $message$ref';
  }
}

/// Exception for persistence layer failures.
class StorageException implements Exception {
  /// Creates a [StorageException] with the given [message] and
  /// optional [cause].
  const StorageException(this.message, {this.cause});

  /// Human-readable description of the storage failure.
  final String message;

  /// The underlying error that caused this exception, if any.
  final Object? cause;

  @override
  String toString() {
    final causeStr = cause != null ? ' (cause: $cause)' : '';
    return 'StorageException: $message$causeStr';
  }
}
