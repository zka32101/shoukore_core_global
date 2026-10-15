import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const decay = MasteryDecay(
    gracePeriod: Duration(days: 7),
    halfLife: Duration(days: 14),
  );

  test('lastPracticedAtが未設定なら減衰しない', () {
    const mastery = Mastery(unitId: 'a', score: 0.8);
    expect(decay.decayedScore(mastery, DateTime(2024, 1, 1)), 0.8);
  });

  test('gracePeriod以内は減衰しない', () {
    final mastery = Mastery(
      unitId: 'a',
      score: 0.8,
      lastPracticedAt: DateTime(2024, 1, 1),
    );
    expect(decay.decayedScore(mastery, DateTime(2024, 1, 5)), 0.8);
  });

  test('gracePeriod直後はほぼ減衰しない', () {
    final mastery = Mastery(
      unitId: 'a',
      score: 0.8,
      lastPracticedAt: DateTime(2024, 1, 1),
    );
    expect(decay.decayedScore(mastery, DateTime(2024, 1, 8)), closeTo(0.8, 0.001));
  });

  test('gracePeriod後、半減期ちょうどでスコアが半分になる', () {
    final mastery = Mastery(
      unitId: 'a',
      score: 0.8,
      lastPracticedAt: DateTime(2024, 1, 1),
    );
    // gracePeriod(7日) + halfLife(14日) = 21日後
    expect(decay.decayedScore(mastery, DateTime(2024, 1, 22)), closeTo(0.4, 0.001));
  });

  test('2回分の半減期でスコアが1/4になる', () {
    final mastery = Mastery(
      unitId: 'a',
      score: 0.8,
      lastPracticedAt: DateTime(2024, 1, 1),
    );
    // gracePeriod(7日) + halfLife*2(28日) = 35日後
    expect(decay.decayedScore(mastery, DateTime(2024, 2, 5)), closeTo(0.2, 0.001));
  });
}
