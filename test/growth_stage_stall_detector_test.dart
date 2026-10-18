import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GrowthStageStallDetector', () {
    test('最終進化から一定期間変化がなければ停滞と判定する', () {
      const detector = GrowthStageStallDetector(stallPeriod: Duration(days: 14));
      final lastEvolvedAt = DateTime(2026, 1, 1);
      final now = DateTime(2026, 1, 20);

      final result = detector.isStalled(
        currentStage: GrowthStage.baby,
        lastEvolvedAt: lastEvolvedAt,
        now: now,
      );

      expect(result, isTrue);
    });

    test('一定期間未満であれば停滞と判定しない', () {
      const detector = GrowthStageStallDetector(stallPeriod: Duration(days: 14));
      final lastEvolvedAt = DateTime(2026, 1, 1);
      final now = DateTime(2026, 1, 5);

      final result = detector.isStalled(
        currentStage: GrowthStage.baby,
        lastEvolvedAt: lastEvolvedAt,
        now: now,
      );

      expect(result, isFalse);
    });

    test('既に最終段階であれば停滞と判定しない', () {
      const detector = GrowthStageStallDetector();
      final lastEvolvedAt = DateTime(2026, 1, 1);
      final now = DateTime(2026, 3, 1);

      final result = detector.isStalled(
        currentStage: GrowthStage.adult,
        lastEvolvedAt: lastEvolvedAt,
        now: now,
      );

      expect(result, isFalse);
    });
  });
}
