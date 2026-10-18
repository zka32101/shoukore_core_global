/// 日次コイン獲得上限に何日も連続で到達し続けている常態化状態を検知する
/// 純関数。`CoinEarningCapPerDay`は単日の上限判定のみを行うため、連日に
/// わたって上限に到達し続けているかどうかは見ない。実際の上限緩和提案・
/// 追加の獲得手段の案内はアプリ側の責務とする。
class CoinEarningCapHabitualHitDetector {
  const CoinEarningCapHabitualHitDetector({this.habitualThreshold = 5});

  /// 連続で上限に到達した日数がこの回数以上なら常態化とみなす。
  final int habitualThreshold;

  /// [consecutiveCapHitDaysNewestFirst]（直近から連続して上限に到達した
  /// 日数の記録、新しい順に真偽値を並べたもの）の先頭から
  /// [habitualThreshold]件が全て`true`であれば、常態化と判定する。
  bool isHabituallyHittingCap(List<bool> consecutiveCapHitDaysNewestFirst) {
    if (consecutiveCapHitDaysNewestFirst.length < habitualThreshold) return false;
    return consecutiveCapHitDaysNewestFirst.take(habitualThreshold).every((hit) => hit);
  }
}
