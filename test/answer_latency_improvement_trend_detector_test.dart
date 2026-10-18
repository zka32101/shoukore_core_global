import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AnswerLatencyImprovementTrendDetector', () {
    test('後半の解答時間が十分短縮していれば改善傾向と判定する', () {
      const detector = AnswerLatencyImprovementTrendDetector();

      final latencies = [
        const Duration(seconds: 10),
        const Duration(seconds: 10),
        const Duration(seconds: 10),
        const Duration(seconds: 3),
        const Duration(seconds: 3),
        const Duration(seconds: 3),
      ];

      expect(detector.isImproving(latencies), isTrue);
    });

    test('解答時間に変化がなければ改善傾向と判定しない', () {
      const detector = AnswerLatencyImprovementTrendDetector();

      final latencies = List.filled(6, const Duration(seconds: 5));

      expect(detector.isImproving(latencies), isFalse);
    });

    test('サンプル数が不足していれば判定しない', () {
      const detector = AnswerLatencyImprovementTrendDetector();

      final latencies = [const Duration(seconds: 10), const Duration(seconds: 1)];

      expect(detector.isImproving(latencies), isFalse);
    });
  });
}
