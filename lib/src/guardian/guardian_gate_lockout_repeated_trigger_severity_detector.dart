/// `GuardianGateLockoutRepeatedTriggerDetector`が検知した繰り返し
/// ロックアウト発生が、さらに深刻な域まで達しているかを判定する
/// 純関数。`GuardianGateLockoutRepeatedTriggerDetector`自体は閾値を
/// 超えたかどうかの単発判定のみを見るため、どの程度深刻かは見ない。
/// 実際の案内の強さの切り分けはアプリ側の責務とする。
class GuardianGateLockoutRepeatedTriggerSeverityDetector {
  const GuardianGateLockoutRepeatedTriggerSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveLockoutCount]（直近から連続してロックアウトが
  /// 発生した回数）が[severeThreshold]以上であれば、深刻な状態と
  /// 判定する。
  bool isSevere(int consecutiveLockoutCount) {
    return consecutiveLockoutCount >= severeThreshold;
  }
}
