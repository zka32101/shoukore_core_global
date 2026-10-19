/// 1日あたりのコイン消費上限（`CoinSpendingLimit`）に何日も連続で達し
/// 続けている常態化状態を検知する純関数。`CoinSpendingLimit`は単日の
/// 上限判定のみを行うため、連日にわたって上限に到達し続けているかは
/// 見ない。`CoinEarningCapHabitualHitDetector`は獲得側の上限の常態化を
/// 見るため対称だが、消費側は見ない別軸。実際の上限緩和提案・使い道の
/// 見直し案内はアプリ側の責務とする。
class CoinSpendingLimitHabitualMaxOutDetector {
  const CoinSpendingLimitHabitualMaxOutDetector({this.habitualThreshold = 5});

  /// 連続で上限に到達した日数がこの回数以上なら常態化とみなす。
  final int habitualThreshold;

  /// [consecutiveMaxOutDaysNewestFirst]（直近から連続して上限に到達した
  /// 日数の記録、新しい順に真偽値を並べたもの）の先頭から
  /// [habitualThreshold]件が全て`true`であれば、常態化と判定する。
  bool isHabituallyMaxingOut(List<bool> consecutiveMaxOutDaysNewestFirst) {
    if (consecutiveMaxOutDaysNewestFirst.length < habitualThreshold) return false;
    return consecutiveMaxOutDaysNewestFirst.take(habitualThreshold).every((hit) => hit);
  }
}
