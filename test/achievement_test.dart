import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const evaluator = AchievementEvaluator();

  group('AchievementEvaluator', () {
    test('初期状態では何も解除されない', () {
      final unlocked = evaluator.evaluate(GrowthSnapshot.initial);
      expect(unlocked, isEmpty);
    });

    test('ストリークの閾値に応じてバッジが解除される', () {
      final unlocked = evaluator.evaluate(
        const GrowthSnapshot(currentStreakDays: 7),
      );
      expect(unlocked, {AchievementId.streakDays3, AchievementId.streakDays7});
    });

    test('累計正答数の閾値に応じてバッジが解除される', () {
      final unlocked = evaluator.evaluate(
        const GrowthSnapshot(totalCorrectAnswers: 100),
      );
      expect(unlocked, {AchievementId.correctAnswers100});
    });

    test('newlyUnlockedは新たに解除されたバッジだけを返す', () {
      const before = GrowthSnapshot(currentStreakDays: 2, totalCorrectAnswers: 99);
      const after = GrowthSnapshot(currentStreakDays: 3, totalCorrectAnswers: 100);
      final newly = evaluator.newlyUnlocked(before: before, after: after);
      expect(newly, {AchievementId.streakDays3, AchievementId.correctAnswers100});
    });

    test('newlyUnlockedは既に解除済みのバッジを含まない', () {
      const before = GrowthSnapshot(currentStreakDays: 3);
      const after = GrowthSnapshot(currentStreakDays: 5);
      final newly = evaluator.newlyUnlocked(before: before, after: after);
      expect(newly, isEmpty);
    });
  });
}
