import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CoinSpendingLimitHabitualMaxOutDetector', () {
    test('連続で閾値日数以上上限に到達していれば常態化と判定する', () {
      const detector = CoinSpendingLimitHabitualMaxOutDetector(habitualThreshold: 3);

      final result = detector.isHabituallyMaxingOut([true, true, true, false]);

      expect(result, isTrue);
    });

    test('連続日数が閾値未満であれば常態化と判定しない', () {
      const detector = CoinSpendingLimitHabitualMaxOutDetector(habitualThreshold: 3);

      final result = detector.isHabituallyMaxingOut([true, true, false]);

      expect(result, isFalse);
    });

    test('記録件数が閾値未満であれば常態化と判定しない', () {
      const detector = CoinSpendingLimitHabitualMaxOutDetector(habitualThreshold: 5);

      final result = detector.isHabituallyMaxingOut([true, true]);

      expect(result, isFalse);
    });
  });
}
