/// `WeakNoteReviewScoreRegressionDetector`が復習後の再テストスコア
/// 悪化を検知した結果が、単発ではなく確認のたびに繰り返し検出され続け
/// ているかを判定する純関数。`WeakNoteReviewScoreRegressionDetector`
/// 自体は直近1回分のスコア比較のみを見るため、繰り返しの発生自体は
/// 見ない。実際の再学習案の表示・保護者への報告方法の見直しはアプリ
/// 側の責務とする。
class WeakNoteReviewScoreRegressionRecurrenceDetector {
  const WeakNoteReviewScoreRegressionRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上悪化が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveRegressionCount]（直近から連続して再テストスコアの
  /// 悪化が検出された回数）が[recurrenceThreshold]以上であれば、
  /// 繰り返し検出されている状態と判定する。
  bool isRecurring(int consecutiveRegressionCount) {
    return consecutiveRegressionCount >= recurrenceThreshold;
  }
}
