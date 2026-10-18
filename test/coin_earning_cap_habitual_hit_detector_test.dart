import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CoinEarningCapHabitualHitDetector', () {
    const detector = CoinEarningCapHabitualHitDetector(habitualThreshold: 5);

    test('直近5日連続で上限到達していれば常態化と判定', () {
      final recent = [true, true, true, true, true];
      expect(detector.isHabituallyHittingCap(recent), isTrue);
    });

    test('直近5日のうち1日でも到達していなければ常態化ではない', () {
      final recent = [true, true, false, true, true];
      expect(detector.isHabituallyHittingCap(recent), isFalse);
    });

    test('件数が閾値未満なら常態化と判定しない', () {
      final recent = [true, true];
      expect(detector.isHabituallyHittingCap(recent), isFalse);
    });
  });
}
