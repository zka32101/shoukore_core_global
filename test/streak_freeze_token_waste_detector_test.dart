import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StreakFreezeTokenWasteDetector', () {
    const detector = StreakFreezeTokenWasteDetector(wasteThreshold: 3);

    test('未使用失効回数が閾値以上なら無駄遣い状態と判定', () {
      expect(detector.isWastingTokens(3), isTrue);
      expect(detector.isWastingTokens(5), isTrue);
    });

    test('未使用失効回数が閾値未満なら無駄遣い状態ではない', () {
      expect(detector.isWastingTokens(2), isFalse);
      expect(detector.isWastingTokens(0), isFalse);
    });
  });
}
