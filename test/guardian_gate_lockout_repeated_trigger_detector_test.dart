import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianGateLockoutRepeatedTriggerDetector', () {
    const detector = GuardianGateLockoutRepeatedTriggerDetector(repeatedTriggerThreshold: 3);

    test('連続ロックアウト発生回数が閾値以上なら繰り返し発生と判定', () {
      expect(detector.isRepeatedlyTriggered(3), isTrue);
      expect(detector.isRepeatedlyTriggered(5), isTrue);
    });

    test('連続ロックアウト発生回数が閾値未満なら繰り返し発生ではない', () {
      expect(detector.isRepeatedlyTriggered(2), isFalse);
    });

    test('連続ロックアウト発生回数が0なら繰り返し発生ではない', () {
      expect(detector.isRepeatedlyTriggered(0), isFalse);
    });
  });
}
