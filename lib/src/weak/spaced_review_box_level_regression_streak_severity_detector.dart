/// `SpacedReviewBoxLevelRegressionStreakDetector`が検知した連続退行
/// パターンが、さらに深刻な域まで達しているかを判定する純関数。
/// `SpacedReviewBoxLevelRegressionStreakDetector`自体は閾値を超えた
/// かどうかの単発判定のみを見るため、どの程度深刻かは見ない。実際
/// の案内の強さの切り分けはアプリ側の責務とする。
class SpacedReviewBoxLevelRegressionStreakSeverityDetector {
  const SpacedReviewBoxLevelRegressionStreakSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveBoxLevelResetCount]（直近から連続して箱レベルが0に
  /// 戻された回数）が[severeThreshold]以上であれば、深刻な状態と
  /// 判定する。
  bool isSevere(int consecutiveBoxLevelResetCount) {
    return consecutiveBoxLevelResetCount >= severeThreshold;
  }
}
