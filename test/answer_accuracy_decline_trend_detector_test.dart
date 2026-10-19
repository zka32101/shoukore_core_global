import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AnswerAccuracyDeclineTrendDetector', () {
    const detector = AnswerAccuracyDeclineTrendDetector(
      minimumSampleSize: 6,
      accuracyDropThreshold: 0.3,
    );

    test('後半の正答率が前半より大きく下がっていれば悪化傾向と判定', () {
      final correctness = [true, true, true, false, false, false];
      expect(detector.isDeclining(correctness), isTrue);
    });

    test('前半後半の正答率がほぼ同じなら悪化傾向ではない', () {
      final correctness = [true, true, false, true, true, false];
      expect(detector.isDeclining(correctness), isFalse);
    });

    test('解答件数が最小サンプル数未満なら判定しない', () {
      final correctness = [true, false, false];
      expect(detector.isDeclining(correctness), isFalse);
    });
  });
}
