import 'package:flutter_test/flutter_test.dart';
import 'package:fabula_tcg_app/core/errors/exceptions.dart';

void main() {
  group('GameRuleException', () {
    test('toString includes message', () {
      const exception = GameRuleException('Test error');
      expect(exception.toString(), contains('Test error'));
    });

    test('toString includes rule reference when provided', () {
      const exception = GameRuleException(
        'Test error',
        ruleReference: '1.7.2c',
      );
      expect(exception.toString(), contains('[Rule 1.7.2c]'));
    });

    test('toString omits rule reference when null', () {
      const exception = GameRuleException('Test error');
      expect(exception.toString(), isNot(contains('[Rule')));
    });
  });

  group('StorageException', () {
    test('toString includes message', () {
      const exception = StorageException('Disk full');
      expect(exception.toString(), contains('Disk full'));
    });

    test('toString includes cause when provided', () {
      final exception = StorageException(
        'Write failed',
        cause: Exception('IO error'),
      );
      expect(exception.toString(), contains('cause:'));
    });
  });
}
