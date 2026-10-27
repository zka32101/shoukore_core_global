import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ImageHintEligibilityDetector', () {
    const detector = ImageHintEligibilityDetector(
      minConsecutiveIncorrectCount: 1,
    );

    test('画像ヒントがあり誤答が閾値以上であれば対象', () {
      expect(detector.isEligible(true, 1), isTrue);
    });

    test('画像ヒントがなければ対象ではない', () {
      expect(detector.isEligible(false, 5), isFalse);
    });

    test('誤答数が閾値未満であれば対象ではない', () {
      expect(detector.isEligible(true, 0), isFalse);
    });
  });
}
