/// `EntitlementGracePeriodRepeatedUsageDetector`が繰り返しパターンと
/// 判定する閾値にまだ到達していないが、あと少しで到達しそうな状態を
/// 検知する純関数。`EntitlementGracePeriodRepeatedUsageDetector`自体
/// は閾値到達後のみを判定し、到達前の接近状態自体は見ない。実際の
/// 早期の更新方法見直し案内の表示はアプリ側の責務とする。
class EntitlementGracePeriodRepeatedUsageApproachingDetector {
  const EntitlementGracePeriodRepeatedUsageApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveGracePeriodUsageCount]（直近から連続して猶予期間が
  /// 使用された課金サイクルの回数）が[repeatedUsageThreshold]未満かつ、
  /// [repeatedUsageThreshold] * (1 - [marginRatio])以上であれば、
  /// 接近状態と判定する。
  bool isApproaching({
    required int consecutiveGracePeriodUsageCount,
    required int repeatedUsageThreshold,
  }) {
    if (consecutiveGracePeriodUsageCount >= repeatedUsageThreshold) {
      return false;
    }
    final marginStart = (repeatedUsageThreshold * (1 - marginRatio)).ceil();
    return consecutiveGracePeriodUsageCount >= marginStart;
  }
}
