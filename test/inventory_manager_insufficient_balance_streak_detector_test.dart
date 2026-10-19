import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('InventoryManagerInsufficientBalanceStreakDetector', () {
    test('連続残高不足回数が閾値以上であれば検知対象と判定する', () {
      const detector = InventoryManagerInsufficientBalanceStreakDetector(streakThreshold: 3);

      expect(detector.isPersistentlyInsufficient(3), isTrue);
    });

    test('連続残高不足回数が閾値未満であれば検知対象と判定しない', () {
      const detector = InventoryManagerInsufficientBalanceStreakDetector(streakThreshold: 3);

      expect(detector.isPersistentlyInsufficient(2), isFalse);
    });

    test('連続残高不足回数が0であれば検知対象と判定しない', () {
      const detector = InventoryManagerInsufficientBalanceStreakDetector();

      expect(detector.isPersistentlyInsufficient(0), isFalse);
    });
  });
}
