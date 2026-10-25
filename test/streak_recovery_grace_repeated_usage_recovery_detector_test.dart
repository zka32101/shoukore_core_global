import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StreakRecoveryGraceRepeatedUsageRecoveryDetector', () {
    const detector = StreakRecoveryGraceRepeatedUsageRecoveryDetector(
      recoveryThreshold: 3,
    );

    test('連続非利用回数が閾値以上であれば解消と判定', () {
      expect(detector.isRecovered(3), isTrue);
    });

    test('連続非利用回数が閾値未満であれば解消ではない', () {
      expect(detector.isRecovered(2), isFalse);
    });

    test('連続非利用回数が0であれば解消ではない', () {
      expect(detector.isRecovered(0), isFalse);
    });
  });
}
