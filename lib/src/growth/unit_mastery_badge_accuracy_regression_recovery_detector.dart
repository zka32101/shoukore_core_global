/// `UnitMasteryBadgeAccuracyRegressionDetector`が検知したマスター後の
/// 正答率悪化が収まり、連続して悪化なしと判定され続けているかを判定
/// する純関数。`UnitMasteryBadgeAccuracyRegressionDetector`自体は
/// マスター時点の正答率との1回分の比較のみを見る単発判定であり、収まった
/// ことの確認自体は見ない。`UnitMasteryBadgeAccuracyRegressionRecurrenceDetector`
/// は悪化が繰り返されているかを見るもので、本クラスはその逆軸（収まった
/// ことの確認）を見る。実際の再学習案の表示解除方法の見直しはアプリ側
/// の責務とする。
class UnitMasteryBadgeAccuracyRegressionRecoveryDetector {
  const UnitMasteryBadgeAccuracyRegressionRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonRegressionCount) {
    return consecutiveNonRegressionCount >= recoveryThreshold;
  }
}
