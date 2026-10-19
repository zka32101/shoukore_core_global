import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('OfflineSessionGapRecurrenceDetector', () {
    const detector = OfflineSessionGapRecurrenceDetector(recurrenceThreshold: 3);

    test('連続長時間ギャップ回数が閾値以上なら習慣的と判定', () {
      expect(detector.isRecurring(3), isTrue);
      expect(detector.isRecurring(5), isTrue);
    });

    test('連続長時間ギャップ回数が閾値未満なら習慣的ではない', () {
      expect(detector.isRecurring(2), isFalse);
    });

    test('連続長時間ギャップ回数が0なら習慣的ではない', () {
      expect(detector.isRecurring(0), isFalse);
    });
  });
}
