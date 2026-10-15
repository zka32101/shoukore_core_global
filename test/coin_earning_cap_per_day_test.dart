import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const cap = CoinEarningCapPerDay(dailyCap: 100);

  test('上限未満なら超過しない', () {
    const state = CoinEarningState(earnedToday: 50);
    expect(cap.wouldExceedCap(state, 20), isFalse);
  });

  test('上限を超える獲得は超過と判定する', () {
    const state = CoinEarningState(earnedToday: 90);
    expect(cap.wouldExceedCap(state, 20), isTrue);
  });

  test('ちょうど上限なら超過しない', () {
    const state = CoinEarningState(earnedToday: 80);
    expect(cap.wouldExceedCap(state, 20), isFalse);
  });

  test('recordEarningは獲得量を加算し時刻を更新する', () {
    const state = CoinEarningState(earnedToday: 30);
    final now = DateTime(2024, 1, 1, 12);
    final updated = cap.recordEarning(state, 10, now);
    expect(updated.earnedToday, 40);
    expect(updated.lastEarnedAt, now);
  });
}
