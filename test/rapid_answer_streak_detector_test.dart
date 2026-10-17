import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('RapidAnswerStreakDetector', () {
    const detector = RapidAnswerStreakDetector();

    test('速すぎる解答がstreakThreshold回以上連続していれば疑わしいと判定する', () {
      final latencies = List.filled(5, const Duration(milliseconds: 100));
      expect(detector.isSuspiciousStreak(latencies), isTrue);
    });

    test('速すぎる解答の連続回数がthreshold未満なら疑わしいと判定しない', () {
      final latencies = [
        const Duration(milliseconds: 100),
        const Duration(milliseconds: 100),
        const Duration(seconds: 2),
        const Duration(milliseconds: 100),
      ];
      expect(detector.isSuspiciousStreak(latencies), isFalse);
    });

    test('直近が妥当な速度であれば疑わしいと判定しない', () {
      final latencies = [
        const Duration(seconds: 2),
        const Duration(milliseconds: 100),
        const Duration(milliseconds: 100),
        const Duration(milliseconds: 100),
        const Duration(milliseconds: 100),
        const Duration(milliseconds: 100),
      ];
      expect(detector.isSuspiciousStreak(latencies), isFalse);
    });
  });
}
