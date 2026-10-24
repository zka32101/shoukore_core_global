/// `ProfileSwitchRevertStreakDetector`が連続発生と判定する閾値に
/// まだ到達していないが、あと少しで到達しそうな状態を検知する純関数。
/// `ProfileSwitchRevertStreakDetector`自体は閾値到達後のみを判定し、
/// 到達前の接近状態自体は見ない。実際の早期の「切替方法を見直します
/// か？」案内の表示はアプリ側の責務とする。
class ProfileSwitchRevertStreakApproachingDetector {
  const ProfileSwitchRevertStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveAccidentalSwitchCount]（直近から連続して誤操作と判定
  /// された切替の回数）が[streakThreshold]未満かつ、
  /// [streakThreshold] * (1 - [marginRatio])以上であれば、接近状態と
  /// 判定する。
  bool isApproaching({
    required int consecutiveAccidentalSwitchCount,
    required int streakThreshold,
  }) {
    if (consecutiveAccidentalSwitchCount >= streakThreshold) {
      return false;
    }
    final marginStart = (streakThreshold * (1 - marginRatio)).ceil();
    return consecutiveAccidentalSwitchCount >= marginStart;
  }
}
