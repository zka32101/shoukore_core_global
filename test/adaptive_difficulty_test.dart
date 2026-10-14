import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const adaptive = AdaptiveDifficulty();

  test('正答率が高い場合は難易度を上げる', () {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final next = adaptive.nextDifficulty(
      currentDifficulty: 0.5,
      recentResults: [true, true, true, true, false],
      clock: clock,
    );
    expect(next, closeTo(0.6, 1e-9));
  });

  test('正答率が低い場合は難易度を下げる', () {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final next = adaptive.nextDifficulty(
      currentDifficulty: 0.5,
      recentResults: [false, false, true],
      clock: clock,
    );
    expect(next, closeTo(0.4, 1e-9));
  });

  test('正答率が中間なら難易度は変化しない', () {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final next = adaptive.nextDifficulty(
      currentDifficulty: 0.5,
      recentResults: [true, false],
      clock: clock,
    );
    expect(next, closeTo(0.5, 1e-9));
  });

  test('難易度は min/max でクランプされる', () {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final next = adaptive.nextDifficulty(
      currentDifficulty: 0.92,
      recentResults: [true, true, true],
      clock: clock,
    );
    expect(next, closeTo(0.95, 1e-9));
  });

  test('一定期間練習が空くと忘却分として難易度を下げる', () {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final next = adaptive.nextDifficulty(
      currentDifficulty: 0.5,
      recentResults: const [],
      lastPracticedAt: DateTime.utc(2026, 10, 1),
      clock: clock,
    );
    expect(next, closeTo(0.4, 1e-9));
  });

  test('結果が無く、空き期間も短ければ難易度は変化しない', () {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final next = adaptive.nextDifficulty(
      currentDifficulty: 0.5,
      recentResults: const [],
      lastPracticedAt: DateTime.utc(2026, 10, 10),
      clock: clock,
    );
    expect(next, closeTo(0.5, 1e-9));
  });

  test('閾値はコンストラクタで差し替え可能（RemoteConfig依存の廃止）', () {
    const custom = AdaptiveDifficulty(step: 0.2, upRate: 0.6, downRate: 0.3);
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final next = custom.nextDifficulty(
      currentDifficulty: 0.5,
      recentResults: [true, true, false],
      clock: clock,
    );
    expect(next, closeTo(0.7, 1e-9));
  });
}
