import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('DuplicateNotificationScheduleRecurrenceDetector', () {
    const detector = DuplicateNotificationScheduleRecurrenceDetector(recurrenceThreshold: 3);

    test('連続発生回数が閾値以上なら繰り返し発生と判定', () {
      expect(detector.isRecurring(3), isTrue);
      expect(detector.isRecurring(5), isTrue);
    });

    test('連続発生回数が閾値未満なら繰り返し発生ではない', () {
      expect(detector.isRecurring(2), isFalse);
    });

    test('連続発生回数が0なら繰り返し発生ではない', () {
      expect(detector.isRecurring(0), isFalse);
    });
  });
}
