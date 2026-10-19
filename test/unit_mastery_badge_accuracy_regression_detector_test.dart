import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('UnitMasteryBadgeAccuracyRegressionDetector', () {
    const detector = UnitMasteryBadgeAccuracyRegressionDetector(
      recentAttemptCount: 4,
      accuracyDropThreshold: 0.3,
    );

    Attempt attempt(bool correct) => Attempt(
          questionId: 'q',
          unitId: 'u1',
          chosenId: correct ? 'a' : 'b',
          correct: correct,
          answeredAt: DateTime(2024, 1, 1),
        );

    test('マスター後の正答率が大きく下がっていれば悪化と判定', () {
      final attempts = [attempt(false), attempt(false), attempt(true), attempt(false)];
      expect(
        detector.hasRegressed(
          masteredAccuracy: 0.9,
          attemptsAfterMasteryNewestFirst: attempts,
        ),
        isTrue,
      );
    });

    test('マスター後の正答率がほぼ同じなら悪化ではない', () {
      final attempts = [attempt(true), attempt(true), attempt(true), attempt(false)];
      expect(
        detector.hasRegressed(
          masteredAccuracy: 0.9,
          attemptsAfterMasteryNewestFirst: attempts,
        ),
        isFalse,
      );
    });

    test('マスター後の解答件数が足りなければ判定しない', () {
      final attempts = [attempt(false), attempt(false)];
      expect(
        detector.hasRegressed(
          masteredAccuracy: 0.9,
          attemptsAfterMasteryNewestFirst: attempts,
        ),
        isFalse,
      );
    });
  });
}
