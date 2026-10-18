import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('DailyReminderNonresponseStreakDetector', () {
    const detector = DailyReminderNonresponseStreakDetector();

    test('連続未達成日数がstreakThreshold以上であれば連続未達成と判定する', () {
      expect(detector.isNonresponseStreak([false, false, false, true]), isTrue);
    });

    test('連続未達成日数がthreshold未満なら判定しない', () {
      expect(detector.isNonresponseStreak([false, false, true, false]), isFalse);
    });

    test('直近が達成済みであれば判定しない', () {
      expect(detector.isNonresponseStreak([true, false, false, false]), isFalse);
    });

    test('空リストでは判定しない', () {
      expect(detector.isNonresponseStreak([]), isFalse);
    });
  });
}
