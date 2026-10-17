import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AchievementProximityHint', () {
    const hint = AchievementProximityHint();

    test('未解除バッジの残り回数を算出する', () {
      const snapshot = GrowthSnapshot(currentStreakDays: 1, totalCorrectAnswers: 90);
      final remaining = hint.remainingToUnlock(snapshot);

      expect(remaining[AchievementId.streakDays3], 2);
      expect(remaining[AchievementId.correctAnswers100], 10);
      expect(remaining.containsKey(AchievementId.streakDays7), isTrue);
    });

    test('解除済みのバッジは残り算出に含めない', () {
      const snapshot = GrowthSnapshot(currentStreakDays: 3, totalCorrectAnswers: 0);
      final remaining = hint.remainingToUnlock(snapshot);

      expect(remaining.containsKey(AchievementId.streakDays3), isFalse);
      expect(remaining[AchievementId.streakDays7], 4);
    });

    test('最も近い未解除バッジを返す', () {
      const snapshot = GrowthSnapshot(currentStreakDays: 0, totalCorrectAnswers: 99);
      expect(hint.closestUnlockedCandidate(snapshot), AchievementId.correctAnswers100);
    });

    test('すべて解除済みの場合はnullを返す', () {
      const snapshot = GrowthSnapshot(currentStreakDays: 30, totalCorrectAnswers: 500);
      expect(hint.closestUnlockedCandidate(snapshot), isNull);
    });
  });
}
