/// `GuardianGateLockoutRepeatedTriggerDetector`が繰り返し発生と判定する
/// 閾値にまだ到達していないが、あと少しで到達しそうな状態を検知する
/// 純関数。`GuardianGateLockoutRepeatedTriggerDetector`自体は閾値到達
/// 後のみを判定し、到達前の接近状態自体は見ない。実際の早期の注意喚起
/// 表示はアプリ側の責務とする。
class GuardianGateLockoutRepeatedTriggerApproachingDetector {
  const GuardianGateLockoutRepeatedTriggerApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveLockoutTriggerCount]（直近から連続してロックアウトが
  /// 発生した回数）が[repeatedTriggerThreshold]未満かつ、
  /// [repeatedTriggerThreshold] * (1 - [marginRatio])以上であれば、
  /// 接近状態と判定する。
  bool isApproaching({
    required int consecutiveLockoutTriggerCount,
    required int repeatedTriggerThreshold,
  }) {
    if (consecutiveLockoutTriggerCount >= repeatedTriggerThreshold) {
      return false;
    }
    final marginStart = (repeatedTriggerThreshold * (1 - marginRatio)).ceil();
    return consecutiveLockoutTriggerCount >= marginStart;
  }
}
