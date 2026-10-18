import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AchievementUnlockClusterDetector', () {
    test('同時解除数が閾値以上であれば密集と判定する', () {
      const detector = AchievementUnlockClusterDetector(clusterThreshold: 2);

      final result = detector.isClustered({
        AchievementId.streakDays3,
        AchievementId.correctAnswers100,
      });

      expect(result, isTrue);
    });

    test('同時解除数が閾値未満であれば密集と判定しない', () {
      const detector = AchievementUnlockClusterDetector(clusterThreshold: 2);

      final result = detector.isClustered({AchievementId.streakDays3});

      expect(result, isFalse);
    });

    test('解除なしであれば密集と判定しない', () {
      const detector = AchievementUnlockClusterDetector();

      final result = detector.isClustered({});

      expect(result, isFalse);
    });
  });
}
