import 'package:flutter_test/flutter_test.dart';

import 'package:fabula_tcg_app/core/utils/player_id.dart';

void main() {
  group('PlayerId', () {
    test('equality by value', () {
      const id1 = PlayerId('player_1');
      const id2 = PlayerId('player_1');
      expect(id1, equals(id2));
    });

    test('inequality for different values', () {
      const id1 = PlayerId('player_1');
      const id2 = PlayerId('player_2');
      expect(id1, isNot(equals(id2)));
    });

    test('hashCode is consistent with equality', () {
      const id1 = PlayerId('player_1');
      const id2 = PlayerId('player_1');
      expect(id1.hashCode, equals(id2.hashCode));
    });

    test('toString returns readable representation', () {
      const id = PlayerId('player_1');
      expect(id.toString(), 'PlayerId(player_1)');
    });
  });
}
