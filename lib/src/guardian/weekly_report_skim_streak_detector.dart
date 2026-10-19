/// `WeeklyReport`が複数週にわたって連続で「流し見」されている状態を検知
/// する純関数。`WeeklyReportSkimDetector`は1件のレポートの閲覧時間から
/// その場の流し見状態のみを判定し、複数週にわたって続いているかは見ない。
/// `WeeklyReportUnopenedStreakDetector`はレポートが開封されずに連続で
/// 放置されている状態を見るものであり、開封はされているが流し見で終わって
/// いる状態とは別物である。実際の通知方法の見直し案内はアプリ側の責務と
/// する。
class WeeklyReportSkimStreakDetector {
  const WeeklyReportSkimStreakDetector({this.streakThreshold = 2})
      : assert(streakThreshold > 0);

  /// 連続してこの週数以上流し見であれば流し見状態とみなす。
  final int streakThreshold;

  /// [consecutiveSkimWeekCount]（直近から連続して流し見だった週次レポート
  /// の件数）が[streakThreshold]以上であれば、流し見状態と判定する。
  bool isPersistentlySkimRead(int consecutiveSkimWeekCount) {
    return consecutiveSkimWeekCount >= streakThreshold;
  }
}
