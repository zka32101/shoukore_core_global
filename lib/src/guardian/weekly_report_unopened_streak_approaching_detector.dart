/// `WeeklyReportUnopenedStreakDetector`が放置状態と判定する閾値に
/// まだ到達していないが、あと少しで到達しそうな状態を検知する純関数。
/// `WeeklyReportUnopenedStreakDetector`自体は閾値到達後のみを判定し、
/// 到達前の接近状態自体は見ない。実際の早期の通知方法見直しは
/// アプリ側の責務とする。
class WeeklyReportUnopenedStreakApproachingDetector {
  const WeeklyReportUnopenedStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveUnopenedWeekCount]（直近から連続して未読だった週次
  /// レポートの件数）が[streakThreshold]未満かつ、
  /// [streakThreshold] * (1 - [marginRatio])以上であれば、接近状態と
  /// 判定する。
  bool isApproaching({
    required int consecutiveUnopenedWeekCount,
    required int streakThreshold,
  }) {
    if (consecutiveUnopenedWeekCount >= streakThreshold) {
      return false;
    }
    final marginStart = (streakThreshold * (1 - marginRatio)).ceil();
    return consecutiveUnopenedWeekCount >= marginStart;
  }
}
