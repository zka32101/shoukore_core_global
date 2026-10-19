import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SpacedReviewBoxLevelRegressionStreakDetector', () {
    const detector = SpacedReviewBoxLevelRegressionStreakDetector(regressionThreshold: 3);

    test('連続リセット回数が閾値以上なら連続退行状態と判定', () {
      expect(detector.isRegressing(3), isTrue);
      expect(detector.isRegressing(5), isTrue);
    });

    test('連続リセット回数が閾値未満なら連続退行状態ではない', () {
      expect(detector.isRegressing(2), isFalse);
    });

    test('連続リセット回数が0なら連続退行状態ではない', () {
      expect(detector.isRegressing(0), isFalse);
    });
  });
}
