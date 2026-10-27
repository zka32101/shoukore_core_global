import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AccomplishmentFeedbackEligibilityDetector', () {
    const detector = AccomplishmentFeedbackEligibilityDetector(
      minAnsweredCount: 3,
    );

    test('解答数が閾値以上であれば対象と判定', () {
      expect(detector.isEligible(3), isTrue);
    });

    test('解答数が閾値未満であれば対象ではない', () {
      expect(detector.isEligible(2), isFalse);
    });

    test('解答数が0であれば対象ではない', () {
      expect(detector.isEligible(0), isFalse);
    });
  });
}
