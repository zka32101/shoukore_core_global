import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SpacedReviewBoxLevelRegressionStreakSeverityDetector', () {
    const detector = SpacedReviewBoxLevelRegressionStreakSeverityDetector(
      severeThreshold: 6,
    );

    test('連続退行回数が閾値以上であれば深刻と判定', () {
      expect(detector.isSevere(6), isTrue);
    });

    test('連続退行回数が閾値未満であれば深刻ではない', () {
      expect(detector.isSevere(5), isFalse);
    });

    test('連続退行回数が0であれば深刻ではない', () {
      expect(detector.isSevere(0), isFalse);
    });
  });
}
