import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ReadAloudEligibilityDetector', () {
    const detector = ReadAloudEligibilityDetector(
      maxGradeForAutoReadAloud: 2,
      longTextThreshold: 40,
    );

    test('学年が閾値以下であれば読み上げ対象', () {
      expect(detector.isEligible(1, 5), isTrue);
    });

    test('学年が閾値超でも問題文が長ければ読み上げ対象', () {
      expect(detector.isEligible(5, 40), isTrue);
    });

    test('学年が閾値超かつ問題文が短ければ読み上げ対象ではない', () {
      expect(detector.isEligible(5, 10), isFalse);
    });
  });
}
