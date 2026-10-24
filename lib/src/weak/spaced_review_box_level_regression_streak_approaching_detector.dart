/// `SpacedReviewBoxLevelRegressionStreakDetector`が連続退行状態と判定
/// する閾値にまだ到達していないが、あと少しで到達しそうな状態を検知
/// する純関数。`SpacedReviewBoxLevelRegressionStreakDetector`自体は
/// 閾値到達後のみを判定し、到達前の接近状態自体は見ない。実際の早期の
/// 「別の教え方で復習しよう」案内の表示はアプリ側の責務とする。
class SpacedReviewBoxLevelRegressionStreakApproachingDetector {
  const SpacedReviewBoxLevelRegressionStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveBoxLevelResetCount]（直近から連続して箱レベルが0に
  /// 戻された回数）が[regressionThreshold]未満かつ、
  /// [regressionThreshold] * (1 - [marginRatio])以上であれば、接近
  /// 状態と判定する。
  bool isApproaching({
    required int consecutiveBoxLevelResetCount,
    required int regressionThreshold,
  }) {
    if (consecutiveBoxLevelResetCount >= regressionThreshold) {
      return false;
    }
    final marginStart = (regressionThreshold * (1 - marginRatio)).ceil();
    return consecutiveBoxLevelResetCount >= marginStart;
  }
}
