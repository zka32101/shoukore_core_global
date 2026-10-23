/// `WeeklyReportSkimDetector`が検知した週次レポートの流し見状態が解消
/// し、連続してしっかり閲覧され続けていると判定されているかを判定する
/// 純関数。`WeeklyReportSkimDetector`自体は1回の開封あたりの閲覧時間
/// のみを見る単発判定であり、解消の確認自体は見ない。実際の「詳しく
/// 見る」案内の解除方法の見直しはアプリ側の責務とする。
class WeeklyReportSkimRecoveryDetector {
  const WeeklyReportSkimRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonSkimCount) {
    return consecutiveNonSkimCount >= recoveryThreshold;
  }
}
