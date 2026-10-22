/// `UnitMasteryBadgeAccuracyRegressionDetector`がマスター後の正答率悪化
/// を検知した結果が、単発ではなく確認のたびに繰り返し検出され続けて
/// いるかを判定する純関数。`UnitMasteryBadgeAccuracyRegressionDetector`
/// 自体はマスター時点の正答率との1回分の比較のみを見るため、繰り返しの
/// 発生自体は見ない。実際の再学習案の表示方法の見直しはアプリ側の責務
/// とする。
class UnitMasteryBadgeAccuracyRegressionRecurrenceDetector {
  const UnitMasteryBadgeAccuracyRegressionRecurrenceDetector({
    this.recurrenceThreshold = 3,
  }) : assert(recurrenceThreshold > 0);

  final int recurrenceThreshold;

  bool isRecurring(int consecutiveRegressionCount) {
    return consecutiveRegressionCount >= recurrenceThreshold;
  }
}
