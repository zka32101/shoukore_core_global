import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('UnitAbandonmentDetector', () {
    const detector = UnitAbandonmentDetector(
      masteredScoreThreshold: 0.8,
      abandonedAfter: Duration(days: 30),
    );
    final now = DateTime(2024, 2, 1);

    test('開始済み・未習熟・長期間放置なら放置状態と判定', () {
      final mastery = Mastery(
        unitId: 'u1',
        score: 0.3,
        lastPracticedAt: now.subtract(const Duration(days: 31)),
      );
      expect(detector.isAbandoned(mastery: mastery, now: now), isTrue);
    });

    test('放置期間が閾値以内なら放置状態ではない', () {
      final mastery = Mastery(
        unitId: 'u1',
        score: 0.3,
        lastPracticedAt: now.subtract(const Duration(days: 10)),
      );
      expect(detector.isAbandoned(mastery: mastery, now: now), isFalse);
    });

    test('既に習熟済みなら放置状態ではない', () {
      final mastery = Mastery(
        unitId: 'u1',
        score: 0.9,
        lastPracticedAt: now.subtract(const Duration(days: 31)),
      );
      expect(detector.isAbandoned(mastery: mastery, now: now), isFalse);
    });

    test('一度も学習していない単元は放置状態ではない', () {
      final mastery = Mastery(unitId: 'u1', score: 0);
      expect(detector.isAbandoned(mastery: mastery, now: now), isFalse);
    });
  });
}
