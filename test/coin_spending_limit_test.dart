import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const limit = CoinSpendingLimit(dailyLimit: 100);

  group('wouldExceedLimit', () {
    test('未消費なら上限以内の購入は許可', () {
      expect(limit.wouldExceedLimit(CoinSpendingState.initial, 50), isFalse);
    });

    test('合計が上限を超えるとtrue', () {
      const state = CoinSpendingState(spentToday: 80);
      expect(limit.wouldExceedLimit(state, 30), isTrue);
    });

    test('合計が上限ちょうどはfalse', () {
      const state = CoinSpendingState(spentToday: 80);
      expect(limit.wouldExceedLimit(state, 20), isFalse);
    });
  });

  test('recordSpendingはspentTodayを加算した状態を返す', () {
    const state = CoinSpendingState(spentToday: 30);
    final now = DateTime(2024, 1, 1, 12, 0);
    final next = limit.recordSpending(state, 20, now);
    expect(next.spentToday, 50);
    expect(next.lastSpentAt, now);
  });

  test('initial状態はspentToday 0', () {
    expect(CoinSpendingState.initial.spentToday, 0);
    expect(CoinSpendingState.initial.lastSpentAt, isNull);
  });
}
