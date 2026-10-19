import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeeklyReportUnopenedStreakDetector', () {
    test('連続未読週数が閾値以上であれば放置状態と判定する', () {
      const detector = WeeklyReportUnopenedStreakDetector(streakThreshold: 2);

      expect(detector.isPersistentlyUnopened(2), isTrue);
    });

    test('連続未読週数が閾値未満であれば放置状態と判定しない', () {
      const detector = WeeklyReportUnopenedStreakDetector(streakThreshold: 2);

      expect(detector.isPersistentlyUnopened(1), isFalse);
    });

    test('連続未読週数が0であれば放置状態と判定しない', () {
      const detector = WeeklyReportUnopenedStreakDetector();

      expect(detector.isPersistentlyUnopened(0), isFalse);
    });
  });
}
