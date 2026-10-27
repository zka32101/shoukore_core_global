import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AccuracyTrendDetector', () {
    const detector = AccuracyTrendDetector();

    test('履歴不足なら steady', () {
      expect(detector.evaluateTrend([0.5]), AccuracyTrend.steady);
    });

    test('後半の正答率が十分上がっていれば improving', () {
      expect(
        detector.evaluateTrend([0.3, 0.3, 0.9, 0.9]),
        AccuracyTrend.improving,
      );
    });

    test('後半の正答率が十分下がっていれば declining', () {
      expect(
        detector.evaluateTrend([0.9, 0.9, 0.3, 0.3]),
        AccuracyTrend.declining,
      );
    });

    test('前半・後半の差が小さければ steady', () {
      expect(
        detector.evaluateTrend([0.6, 0.62, 0.58, 0.6]),
        AccuracyTrend.steady,
      );
    });
  });
}
