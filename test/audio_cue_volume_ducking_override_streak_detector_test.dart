import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AudioCueVolumeDuckingOverrideStreakDetector', () {
    const detector = AudioCueVolumeDuckingOverrideStreakDetector(overrideStreakThreshold: 3);

    test('連続上書き回数が閾値以上なら連続上書き状態と判定', () {
      expect(detector.isOverriding(3), isTrue);
      expect(detector.isOverriding(5), isTrue);
    });

    test('連続上書き回数が閾値未満なら連続上書き状態ではない', () {
      expect(detector.isOverriding(2), isFalse);
    });

    test('連続上書き回数が0なら連続上書き状態ではない', () {
      expect(detector.isOverriding(0), isFalse);
    });
  });
}
