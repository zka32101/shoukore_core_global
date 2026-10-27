import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CollectionCompletionDetector', () {
    const detector = CollectionCompletionDetector(
      milestoneRatios: [0.5, 0.8, 1.0],
    );

    test('所持比率が節目に到達していれば対象と判定', () {
      expect(detector.isMilestoneReached(5, 10), isTrue);
    });

    test('所持比率が節目未達であれば対象ではない', () {
      expect(detector.isMilestoneReached(3, 10), isFalse);
    });

    test('全てコンプリートしていれば対象と判定', () {
      expect(detector.isMilestoneReached(10, 10), isTrue);
    });

    test('総数が0であれば対象ではない', () {
      expect(detector.isMilestoneReached(0, 0), isFalse);
    });
  });
}
