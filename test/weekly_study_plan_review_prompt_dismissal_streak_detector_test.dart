import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeeklyStudyPlanReviewPromptDismissalStreakDetector', () {
    const detector = WeeklyStudyPlanReviewPromptDismissalStreakDetector(
      streakThreshold: 2,
    );

    test('閾値以上連続無視なら放置状態', () {
      expect(detector.isPersistentlyDismissed(2), isTrue);
      expect(detector.isPersistentlyDismissed(3), isTrue);
    });

    test('閾値未満なら放置状態ではない', () {
      expect(detector.isPersistentlyDismissed(1), isFalse);
      expect(detector.isPersistentlyDismissed(0), isFalse);
    });
  });
}
