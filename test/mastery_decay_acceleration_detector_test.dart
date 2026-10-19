import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('MasteryDecayAccelerationDetector', () {
    const detector = MasteryDecayAccelerationDetector(worseningStreakThreshold: 3);

    test('連続悪化回数が閾値以上なら悪化トレンドと判定', () {
      expect(detector.isAccelerating(3), isTrue);
      expect(detector.isAccelerating(5), isTrue);
    });

    test('連続悪化回数が閾値未満なら悪化トレンドではない', () {
      expect(detector.isAccelerating(2), isFalse);
    });

    test('連続悪化回数が0なら悪化トレンドではない', () {
      expect(detector.isAccelerating(0), isFalse);
    });
  });
}
