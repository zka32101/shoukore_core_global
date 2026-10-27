import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ChoiceOrderRandomizer', () {
    test('元のリストと同じ要素をすべて含む', () {
      final randomizer = ChoiceOrderRandomizer(random: Random(1));
      final result = randomizer.shuffle(['a', 'b', 'c', 'd']);
      expect(result, containsAll(['a', 'b', 'c', 'd']));
      expect(result.length, 4);
    });

    test('元のリストを変更しない', () {
      final randomizer = ChoiceOrderRandomizer(random: Random(1));
      final original = ['a', 'b', 'c', 'd'];
      randomizer.shuffle(original);
      expect(original, ['a', 'b', 'c', 'd']);
    });

    test('同じシードであれば同じ順序を返す', () {
      final randomizer1 = ChoiceOrderRandomizer(random: Random(42));
      final randomizer2 = ChoiceOrderRandomizer(random: Random(42));
      final result1 = randomizer1.shuffle(['a', 'b', 'c', 'd']);
      final result2 = randomizer2.shuffle(['a', 'b', 'c', 'd']);
      expect(result1, result2);
    });
  });
}
