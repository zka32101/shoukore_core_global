/// `StreakRecoveryGraceRepeatedUsageDetector`が繰り返しパターンと判定
/// する閾値にまだ到達していないが、あと少しで到達しそうな状態を検知
/// する純関数。`StreakRecoveryGraceRepeatedUsageDetector`自体は閾値
/// 到達後のみを判定し、到達前の接近状態自体は見ない。実際の早期の
/// 学習習慣の見直し案内はアプリ側の責務とする。
class StreakRecoveryGraceRepeatedUsageApproachingDetector {
  const StreakRecoveryGraceRepeatedUsageApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveGraceUsageCount]（直近から連続して見逃し猶予が使用された
  /// 回数）が[repeatedUsageThreshold]未満かつ、
  /// [repeatedUsageThreshold] * (1 - [marginRatio])以上であれば、接近
  /// 状態と判定する。
  bool isApproaching({
    required int consecutiveGraceUsageCount,
    required int repeatedUsageThreshold,
  }) {
    if (consecutiveGraceUsageCount >= repeatedUsageThreshold) {
      return false;
    }
    final marginStart =
        (repeatedUsageThreshold * (1 - marginRatio)).ceil();
    return consecutiveGraceUsageCount >= marginStart;
  }
}
