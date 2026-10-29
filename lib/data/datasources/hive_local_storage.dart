import 'package:hive/hive.dart';

import 'package:fabula_tcg_app/core/errors/exceptions.dart';
import 'package:fabula_tcg_app/domain/repositories/local_storage_repository.dart';

/// Hive-based implementation of [LocalStorageRepository].
///
/// Provides offline-first key-value persistence on the device.
class HiveLocalStorageRepository implements LocalStorageRepository {
  /// Creates a [HiveLocalStorageRepository] backed by the given [box].
  const HiveLocalStorageRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<void> save({required String key, required dynamic value}) async {
    try {
      await _box.put(key, value);
    } catch (e) {
      throw StorageException('Failed to save key "$key"', cause: e);
    }
  }

  @override
  Future<dynamic> read({required String key}) async {
    try {
      return _box.get(key);
    } catch (e) {
      throw StorageException('Failed to read key "$key"', cause: e);
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _box.delete(key);
    } catch (e) {
      throw StorageException('Failed to delete key "$key"', cause: e);
    }
  }

  @override
  Future<bool> exists({required String key}) async {
    return _box.containsKey(key);
  }

  @override
  Future<void> clearAll() async {
    try {
      await _box.clear();
    } catch (e) {
      throw StorageException('Failed to clear storage', cause: e);
    }
  }
}
