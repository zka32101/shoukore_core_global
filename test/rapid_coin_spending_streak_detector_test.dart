import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('RapidCoinSpendingStreakDetector', () {
    const detector = RapidCoinSpendingStreakDetector();
    final baseTime = DateTime(2026, 1, 1, 10, 0, 0);

    test('大きな消費が連続していれば疑わしいと判定する', () {
      final events = [
        CoinSpendingEvent(amount: 150, spentAt: baseTime),
        CoinSpendingEvent(amount: 120, spentAt: baseTime.subtract(const Duration(minutes: 1))),
        CoinSpendingEvent(amount: 200, spentAt: baseTime.subtract(const Duration(minutes: 2))),
      ];
      expect(detector.isSuspiciousStreak(events), isTrue);
    });

    test('連続回数がthreshold未満なら疑わしいと判定しない', () {
      final events = [
        CoinSpendingEvent(amount: 150, spentAt: baseTime),
        CoinSpendingEvent(amount: 120, spentAt: baseTime.subtract(const Duration(minutes: 1))),
        CoinSpendingEvent(amount: 10, spentAt: baseTime.subtract(const Duration(minutes: 2))),
      ];
      expect(detector.isSuspiciousStreak(events), isFalse);
    });

    test('streakWindowを超えた間隔があれば連続とみなさない', () {
      final events = [
        CoinSpendingEvent(amount: 150, spentAt: baseTime),
        CoinSpendingEvent(amount: 120, spentAt: baseTime.subtract(const Duration(minutes: 1))),
        CoinSpendingEvent(amount: 200, spentAt: baseTime.subtract(const Duration(minutes: 30))),
      ];
      expect(detector.isSuspiciousStreak(events), isFalse);
    });

    test('直近が小さい消費であれば疑わしいと判定しない', () {
      final events = [
        CoinSpendingEvent(amount: 10, spentAt: baseTime),
        CoinSpendingEvent(amount: 150, spentAt: baseTime.subtract(const Duration(minutes: 1))),
        CoinSpendingEvent(amount: 150, spentAt: baseTime.subtract(const Duration(minutes: 2))),
      ];
      expect(detector.isSuspiciousStreak(events), isFalse);
    });
  });
}
