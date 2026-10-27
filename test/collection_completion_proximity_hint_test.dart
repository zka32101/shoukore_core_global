import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CollectionCompletionProximityHint', () {
    const hint = CollectionCompletionProximityHint();

    test('最初の節目(0.5)までの残りを返す', () {
      expect(hint.remainingToNextMilestone(2, 10), 3);
    });

    test('次の節目(0.8)までの残りを返す', () {
      expect(hint.remainingToNextMilestone(5, 10), 3);
    });

    test('最後の節目(1.0)に到達済みならnullを返す', () {
      expect(hint.remainingToNextMilestone(10, 10), isNull);
    });

    test('totalCountが0以下ならnullを返す', () {
      expect(hint.remainingToNextMilestone(0, 0), isNull);
    });
  });
}
