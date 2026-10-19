import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AnswerLatencyVarianceSpikeDetector', () {
    const detector = AnswerLatencyVarianceSpikeDetector(
      minimumSampleSize: 4,
      varianceRatioThreshold: 0.5,
    );

    test('速い解答と遅い解答が交互なら不安定と判定', () {
      final latencies = [
        const Duration(seconds: 1),
        const Duration(seconds: 10),
        const Duration(seconds: 1),
        const Duration(seconds: 10),
      ];
      expect(detector.isSpiking(latencies), isTrue);
    });

    test('解答時間がほぼ一定なら不安定ではない', () {
      final latencies = [
        const Duration(seconds: 5),
        const Duration(seconds: 5),
        const Duration(seconds: 5),
        const Duration(seconds: 5),
      ];
      expect(detector.isSpiking(latencies), isFalse);
    });

    test('件数が最小サンプル数未満なら判定しない', () {
      final latencies = [const Duration(seconds: 1), const Duration(seconds: 10)];
      expect(detector.isSpiking(latencies), isFalse);
    });
  });
}
