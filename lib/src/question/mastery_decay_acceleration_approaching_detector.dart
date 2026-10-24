/// `MasteryDecayAccelerationDetector`が悪化トレンドと判定する閾値に
/// まだ到達していないが、あと少しで到達しそうな状態を検知する純関数。
/// `MasteryDecayAccelerationDetector`自体は閾値到達後のみを判定し、
/// 到達前の接近状態自体は見ない。実際の早期の学習ペース見直し案内は
/// アプリ側の責務とする。
class MasteryDecayAccelerationApproachingDetector {
  const MasteryDecayAccelerationApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveWorseningCheckCount]（直近から連続して前回より減衰量
  /// が増大した確認回数）が[worseningStreakThreshold]未満かつ、
  /// [worseningStreakThreshold] * (1 - [marginRatio])以上であれば、
  /// 接近状態と判定する。
  bool isApproaching({
    required int consecutiveWorseningCheckCount,
    required int worseningStreakThreshold,
  }) {
    if (consecutiveWorseningCheckCount >= worseningStreakThreshold) {
      return false;
    }
    final marginStart =
        (worseningStreakThreshold * (1 - marginRatio)).ceil();
    return consecutiveWorseningCheckCount >= marginStart;
  }
}
