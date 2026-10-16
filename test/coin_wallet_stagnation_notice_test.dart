import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = CoinWalletStagnationNotice(
    stagnationPeriod: Duration(days: 14),
    minimumBalance: 1,
  );
  final now = DateTime(2024, 1, 15);

  test('残高が0なら滞留と判定しない', () {
    expect(
      notice.isStagnant(
        balance: 0,
        lastSpentAt: null,
        sinceEarnedAt: DateTime(2024, 1, 1),
        now: now,
      ),
      isFalse,
    );
  });

  test('最近使っていれば滞留と判定しない', () {
    expect(
      notice.isStagnant(
        balance: 100,
        lastSpentAt: DateTime(2024, 1, 10),
        sinceEarnedAt: DateTime(2023, 12, 1),
        now: now,
      ),
      isFalse,
    );
  });

  test('一度も使わず獲得から長期間経てば滞留と判定する', () {
    expect(
      notice.isStagnant(
        balance: 100,
        lastSpentAt: null,
        sinceEarnedAt: DateTime(2023, 12, 1),
        now: now,
      ),
      isTrue,
    );
  });

  test('最後に使った時刻から長期間経てば滞留と判定する', () {
    expect(
      notice.isStagnant(
        balance: 100,
        lastSpentAt: DateTime(2023, 12, 1),
        sinceEarnedAt: DateTime(2023, 11, 1),
        now: now,
      ),
      isTrue,
    );
  });
}
