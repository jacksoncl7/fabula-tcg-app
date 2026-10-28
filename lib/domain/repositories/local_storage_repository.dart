/// Abstract contract for local match persistence.
///
/// Implementations provide offline-first storage of match history,
/// player preferences, and game state snapshots.
abstract class LocalStorageRepository {
  /// Saves a value identified by [key].
  Future<void> save({required String key, required dynamic value});

  /// Retrieves a value by [key], or `null` if not found.
  Future<dynamic> read({required String key});

  /// Deletes the value identified by [key].
  Future<void> delete({required String key});

  /// Returns `true` if a value with [key] exists.
  Future<bool> exists({required String key});

  /// Clears all stored data.
  Future<void> clearAll();
}
