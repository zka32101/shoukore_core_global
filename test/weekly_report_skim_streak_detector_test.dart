import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeeklyReportSkimStreakDetector', () {
    const detector = WeeklyReportSkimStreakDetector(streakThreshold: 2);

    test('連続流し見週数が閾値以上なら流し見状態と判定', () {
      expect(detector.isPersistentlySkimRead(2), isTrue);
      expect(detector.isPersistentlySkimRead(4), isTrue);
    });

    test('連続流し見週数が閾値未満なら流し見状態ではない', () {
      expect(detector.isPersistentlySkimRead(1), isFalse);
    });

    test('連続流し見週数が0なら流し見状態ではない', () {
      expect(detector.isPersistentlySkimRead(0), isFalse);
    });
  });
}
