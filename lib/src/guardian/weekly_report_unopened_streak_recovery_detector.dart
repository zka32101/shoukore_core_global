/// `WeeklyReportUnopenedStreakDetector`が検知した週次レポートの連続
/// 未読放置状態が解消し、連続して開封されるようになったと判定され
/// 続けているかを判定する純関数。
/// `WeeklyReportUnopenedStreakDetector`自体は放置状態の有無のみを見る
/// 単発判定であり、解消の確認自体は見ない。実際の通知方法の見直し
/// 案内の解除方法はアプリ側の責務とする。
class WeeklyReportUnopenedStreakRecoveryDetector {
  const WeeklyReportUnopenedStreakRecoveryDetector({
    this.recoveryThreshold = 2,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveOpenedWeekCount]（直近から連続して開封された週次
  /// レポートの件数）が[recoveryThreshold]以上であれば、解消状態と
  /// 判定する。
  bool isRecovered(int consecutiveOpenedWeekCount) {
    return consecutiveOpenedWeekCount >= recoveryThreshold;
  }
}
