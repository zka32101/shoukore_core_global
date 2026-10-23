/// `WeakNoteReviewScoreRegressionDetector`が検知した再テストスコアの
/// 悪化が収まり、連続して悪化なしと判定され続けているかを判定する純
/// 関数。`WeakNoteReviewScoreRegressionDetector`自体は完了時スコアとの
/// 1回分の比較のみを見る単発判定であり、収まったことの確認自体は見ない。
/// `WeakNoteReviewScoreRegressionRecurrenceDetector`は悪化が繰り返され
/// ているかを見るもので、本クラスはその逆軸（収まったことの確認）を
/// 見る。実際の再学習案の表示解除・保護者への報告はアプリ側の責務と
/// する。
class WeakNoteReviewScoreRegressionRecoveryDetector {
  const WeakNoteReviewScoreRegressionRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonRegressionCount) {
    return consecutiveNonRegressionCount >= recoveryThreshold;
  }
}
