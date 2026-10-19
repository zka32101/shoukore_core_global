import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeakNoteReviewScoreRegressionDetector', () {
    const detector = WeakNoteReviewScoreRegressionDetector(scoreDropThreshold: 0.2);

    test('再テストスコアが大きく下がっていれば悪化と判定', () {
      expect(
        detector.hasRegressed(completedScore: 0.9, retestScore: 0.6),
        isTrue,
      );
    });

    test('再テストスコアがほぼ同じなら悪化ではない', () {
      expect(
        detector.hasRegressed(completedScore: 0.9, retestScore: 0.85),
        isFalse,
      );
    });

    test('再テストスコアが上がっていれば悪化ではない', () {
      expect(
        detector.hasRegressed(completedScore: 0.8, retestScore: 0.95),
        isFalse,
      );
    });
  });
}
