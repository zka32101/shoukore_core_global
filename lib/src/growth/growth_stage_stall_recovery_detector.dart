/// `GrowthStageStallDetector`が検知した成長段階の停滞が解消し、連続して
/// 停滞なしと判定され続けているかを判定する純関数。`GrowthStageStallDetector`
/// 自体は直近1回分の比較のみを見るため、解消の確認自体は見ない。
/// `GrowthStageStallRecurrenceDetector`は停滞が繰り返されているかを見る
/// もので、本クラスはその逆軸（解消の確認）を見る。実際の「学習を続け
/// よう」案内の解除方法の見直しはアプリ側の責務とする。
class GrowthStageStallRecoveryDetector {
  const GrowthStageStallRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonStallCount) {
    return consecutiveNonStallCount >= recoveryThreshold;
  }
}
