import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CrossPromoEligibilityDetector', () {
    const detector = CrossPromoEligibilityDetector(
      minMasteredUnitCount: 5,
      maxDismissalCount: 3,
    );

    test('習得単元数十分かつ無視回数が閾値未満であれば対象', () {
      expect(detector.isEligible(5, 0), isTrue);
    });

    test('習得単元数が不足していれば対象ではない', () {
      expect(detector.isEligible(4, 0), isFalse);
    });

    test('無視回数が閾値以上であれば対象ではない', () {
      expect(detector.isEligible(10, 3), isFalse);
    });
  });
}
