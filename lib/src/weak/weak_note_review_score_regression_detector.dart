/// 一度完了とマークした弱点ノートの復習セッションについて、その後の
/// 再テストスコアが前回の完了時スコアより下がっているかを判定する純
/// 関数。`WeakNoteMisconceptionRelapse`は誤解タイプが再び誤答された
/// かという種類の再発のみを見るため、数値的なスコアの悪化は見ない。
/// `WeakNoteReviewOverdueEscalation`は復習期限の超過タイミングのみを
/// 見るため、スコアそのものは見ない。実際の再学習案の表示・保護者への
/// 報告はアプリ側の責務とする。
class WeakNoteReviewScoreRegressionDetector {
  const WeakNoteReviewScoreRegressionDetector({this.scoreDropThreshold = 0.2})
      : assert(scoreDropThreshold > 0);

  /// 完了時スコアとの差がこれ以上であれば悪化とみなす。
  final double scoreDropThreshold;

  /// [completedScore]（前回完了とマークした時点のスコア）に対して
  /// [retestScore]（その後の再テストスコア）が[scoreDropThreshold]以上
  /// 下がっていれば悪化と判定する。
  bool hasRegressed({required double completedScore, required double retestScore}) {
    return (completedScore - retestScore) >= scoreDropThreshold;
  }
}
