/// 間隔反復（Leitner方式）の箱レベルが連続して0に戻され続けている
/// （連続して誤答し続けている）問題を検知する純関数。
/// `SpacedReviewOverdueBacklogAlert`は復習期限到来件数の積み上がりのみを
/// 見るため、特定の問題が繰り返し失敗しているかは見ない。実際の
/// 「別の教え方で復習しよう」案内の表示はアプリ側の責務とする。
class SpacedReviewBoxLevelRegressionStreakDetector {
  const SpacedReviewBoxLevelRegressionStreakDetector({this.regressionThreshold = 3})
      : assert(regressionThreshold > 0);

  /// 連続して箱レベル0に戻った回数がこの回数以上になったら検知対象と
  /// みなす。
  final int regressionThreshold;

  /// [consecutiveBoxLevelResetCount]（直近から連続して箱レベルが0に
  /// 戻された回数）が[regressionThreshold]以上であれば、連続退行状態と
  /// 判定する。
  bool isRegressing(int consecutiveBoxLevelResetCount) {
    return consecutiveBoxLevelResetCount >= regressionThreshold;
  }
}
