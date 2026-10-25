/// `WeeklyReportSkimStreakDetector`が検知した週次レポートの連続流し
/// 見状態が解消し、連続してじっくり読まれるようになったと判定され
/// 続けているかを判定する純関数。
/// `WeeklyReportSkimStreakDetector`自体は流し見状態の有無のみを見る
/// 単発判定であり、解消の確認自体は見ない。実際の通知方法の見直し
/// 案内の解除方法はアプリ側の責務とする。
class WeeklyReportSkimStreakRecoveryDetector {
  const WeeklyReportSkimStreakRecoveryDetector({
    this.recoveryThreshold = 2,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveNonSkimWeekCount]（直近から連続して流し見ではなかった
  /// 週次レポートの件数）が[recoveryThreshold]以上であれば、解消状態と
  /// 判定する。
  bool isRecovered(int consecutiveNonSkimWeekCount) {
    return consecutiveNonSkimWeekCount >= recoveryThreshold;
  }
}
