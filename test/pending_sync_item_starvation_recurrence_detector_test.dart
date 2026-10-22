import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('PendingSyncItemStarvationRecurrenceDetector', () {
    const detector = PendingSyncItemStarvationRecurrenceDetector(recurrenceThreshold: 3);

    test('連続検出回数が閾値以上なら繰り返し検出状態と判定', () {
      expect(detector.isRecurring(3), isTrue);
      expect(detector.isRecurring(5), isTrue);
    });

    test('連続検出回数が閾値未満なら繰り返し検出状態ではない', () {
      expect(detector.isRecurring(2), isFalse);
    });

    test('連続検出回数が0なら繰り返し検出状態ではない', () {
      expect(detector.isRecurring(0), isFalse);
    });
  });
}
