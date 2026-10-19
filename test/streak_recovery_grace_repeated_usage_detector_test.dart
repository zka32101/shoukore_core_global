import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StreakRecoveryGraceRepeatedUsageDetector', () {
    const detector = StreakRecoveryGraceRepeatedUsageDetector(repeatedUsageThreshold: 3);

    test('連続使用回数が閾値以上なら繰り返しパターンと判定', () {
      expect(detector.isRepeatedlyUsed(3), isTrue);
      expect(detector.isRepeatedlyUsed(5), isTrue);
    });

    test('連続使用回数が閾値未満なら繰り返しパターンではない', () {
      expect(detector.isRepeatedlyUsed(2), isFalse);
    });

    test('連続使用回数が0なら繰り返しパターンではない', () {
      expect(detector.isRepeatedlyUsed(0), isFalse);
    });
  });
}
