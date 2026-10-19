import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AdaptiveDifficultyOscillationDetector', () {
    const detector = AdaptiveDifficultyOscillationDetector(reversalThreshold: 4);

    test('反転が閾値以上なら振動と判定', () {
      final values = [1.0, 2.0, 1.0, 2.0, 1.0, 2.0];
      expect(detector.isOscillating(values), isTrue);
    });

    test('一方向への単調な変化なら振動ではない', () {
      final values = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5];
      expect(detector.isOscillating(values), isFalse);
    });

    test('件数が少なすぎる場合は振動と判定しない', () {
      expect(detector.isOscillating([1.0, 2.0]), isFalse);
    });
  });
}
