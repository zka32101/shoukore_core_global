import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('RegionalProfileChangeRecoveryDetector', () {
    const detector = RegionalProfileChangeRecoveryDetector(
      recoveryThreshold: 3,
    );

    test('連続非検出回数が閾値以上なら解消状態と判定', () {
      expect(detector.isRecovered(3), isTrue);
      expect(detector.isRecovered(5), isTrue);
    });

    test('連続非検出回数が閾値未満なら解消状態ではない', () {
      expect(detector.isRecovered(2), isFalse);
    });

    test('連続非検出回数が0なら解消状態ではない', () {
      expect(detector.isRecovered(0), isFalse);
    });
  });
}
