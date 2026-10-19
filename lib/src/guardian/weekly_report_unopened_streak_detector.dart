/// 週次レポートが複数週にわたって連続で未読のまま放置されている状態を
/// 検知する純関数。`ReportReadTimeoutEscalation`は最終既読からの経過時間
/// のみを見るため、週単位で何回連続して未読だったかは見ない。
/// `ReportReadState`自体は既読時刻の記録・問い合わせのみを担う。実際の
/// 通知方法の見直し案内はアプリ側の責務とする。
class WeeklyReportUnopenedStreakDetector {
  const WeeklyReportUnopenedStreakDetector({this.streakThreshold = 2});

  /// 連続してこの週数以上未読であれば放置状態とみなす。
  final int streakThreshold;

  /// [consecutiveUnopenedWeekCount]（直近から連続して未読だった週次
  /// レポートの件数）が[streakThreshold]以上であれば、放置状態と判定する。
  bool isPersistentlyUnopened(int consecutiveUnopenedWeekCount) {
    return consecutiveUnopenedWeekCount >= streakThreshold;
  }
}
