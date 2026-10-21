/// `QuestionDifficultyDriftAlert`による難易度急変アラートが連続して
/// 無視され続けている状態を検知する純関数。`QuestionDifficultyDriftAlert`
/// 自体は直近の難易度変化量のみを見る単発判定であり、出した後にユーザー
/// （保護者）がどう反応したかは見ない。実際の表示方法の見直し案内は
/// アプリ側の責務とする。
class QuestionDifficultyDriftAlertDismissalStreakDetector {
  const QuestionDifficultyDriftAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された難易度急変
  /// アラートの回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
