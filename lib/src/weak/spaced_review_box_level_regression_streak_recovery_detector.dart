/// `SpacedReviewBoxLevelRegressionStreakDetector`が検知した間隔反復
/// 箱レベルの連続退行状態が解消し、連続して箱レベルが上昇するように
/// なったと判定され続けているかを判定する純関数。
/// `SpacedReviewBoxLevelRegressionStreakDetector`自体は連続退行の
/// 有無のみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 「別の教え方で復習しよう」案内の解除方法はアプリ側の責務とする。
class SpacedReviewBoxLevelRegressionStreakRecoveryDetector {
  const SpacedReviewBoxLevelRegressionStreakRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveBoxLevelAdvanceCount]（直近から連続して箱レベルが
  /// 上昇した回数）が[recoveryThreshold]以上であれば、解消状態と
  /// 判定する。
  bool isRecovered(int consecutiveBoxLevelAdvanceCount) {
    return consecutiveBoxLevelAdvanceCount >= recoveryThreshold;
  }
}
