/// `GuardianApprovalRequestRepeatedRejectionStreakDetector`が連続却下
/// 状態と判定する閾値にまだ到達していないが、あと少しで到達しそうな
/// 状態を検知する純関数。
/// `GuardianApprovalRequestRepeatedRejectionStreakDetector`自体は閾値
/// 到達後のみを判定し、到達前の接近状態自体は見ない。実際の早期の
/// 再申請制限・案内表示はアプリ側の責務とする。
class GuardianApprovalRequestRepeatedRejectionStreakApproachingDetector {
  const GuardianApprovalRequestRepeatedRejectionStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveRejectionCount]（直近から連続して却下された申請の回数）
  /// が[rejectionThreshold]未満かつ、
  /// [rejectionThreshold] * (1 - [marginRatio])以上であれば、接近状態と
  /// 判定する。
  bool isApproaching({
    required int consecutiveRejectionCount,
    required int rejectionThreshold,
  }) {
    if (consecutiveRejectionCount >= rejectionThreshold) {
      return false;
    }
    final marginStart = (rejectionThreshold * (1 - marginRatio)).ceil();
    return consecutiveRejectionCount >= marginStart;
  }
}
