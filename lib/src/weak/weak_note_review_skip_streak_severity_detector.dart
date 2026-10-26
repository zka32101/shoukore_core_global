/// `WeakNoteReviewSkipStreakDetector`が検知した連続スキップパターン
/// が、さらに深刻な域まで達しているかを判定する純関数。
/// `WeakNoteReviewSkipStreakDetector`自体は閾値を超えたかどうかの
/// 単発判定のみを見るため、どの程度深刻かは見ない。実際の案内の
/// 強さの切り分けはアプリ側の責務とする。
class WeakNoteReviewSkipStreakSeverityDetector {
  const WeakNoteReviewSkipStreakSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveSkipCount]（直近から連続して弱点ノートのレビューを
  /// スキップした回数）が[severeThreshold]以上であれば、深刻な状態と
  /// 判定する。
  bool isSevere(int consecutiveSkipCount) {
    return consecutiveSkipCount >= severeThreshold;
  }
}
