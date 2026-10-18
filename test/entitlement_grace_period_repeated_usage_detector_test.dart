import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('EntitlementGracePeriodRepeatedUsageDetector', () {
    test('連続利用回数が閾値以上であれば繰り返しパターンと判定する', () {
      const detector = EntitlementGracePeriodRepeatedUsageDetector(repeatedUsageThreshold: 3);

      expect(detector.isRepeatedlyUsed(3), isTrue);
    });

    test('連続利用回数が閾値未満であれば繰り返しパターンと判定しない', () {
      const detector = EntitlementGracePeriodRepeatedUsageDetector(repeatedUsageThreshold: 3);

      expect(detector.isRepeatedlyUsed(2), isFalse);
    });

    test('連続利用回数が0であれば繰り返しパターンと判定しない', () {
      const detector = EntitlementGracePeriodRepeatedUsageDetector();

      expect(detector.isRepeatedlyUsed(0), isFalse);
    });
  });
}
