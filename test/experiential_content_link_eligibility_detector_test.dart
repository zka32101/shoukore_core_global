import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ExperientialContentLinkEligibilityDetector', () {
    const detector = ExperientialContentLinkEligibilityDetector(
      minAccuracyRatio: 0.5,
    );

    test('体験型コンテンツがあり正答率が十分であれば対象', () {
      expect(detector.isEligible(true, 0.5), isTrue);
    });

    test('体験型コンテンツがなければ対象ではない', () {
      expect(detector.isEligible(false, 1.0), isFalse);
    });

    test('正答率が不十分であれば対象ではない', () {
      expect(detector.isEligible(true, 0.4), isFalse);
    });
  });
}
