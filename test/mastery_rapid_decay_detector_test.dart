import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = MasteryRapidDecayDetector(decayAmountThreshold: 0.3);
  final now = DateTime(2024, 2, 1);

  test('最近学習していれば急激な減衰と判定しない', () {
    final mastery = Mastery(
      unitId: 'u1',
      score: 0.8,
      lastPracticedAt: now.subtract(const Duration(days: 1)),
    );
    expect(detector.isDecayingRapidly(mastery, now), isFalse);
  });

  test('長期間学習していないスコアの高い単元は急激な減衰と判定する', () {
    final mastery = Mastery(
      unitId: 'u1',
      score: 0.9,
      lastPracticedAt: now.subtract(const Duration(days: 60)),
    );
    expect(detector.isDecayingRapidly(mastery, now), isTrue);
  });
}
