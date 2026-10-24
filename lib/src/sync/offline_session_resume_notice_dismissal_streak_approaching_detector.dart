/// `OfflineSessionResumeNoticeDismissalStreakDetector`が連続無視状態
/// と判定する閾値にまだ到達していないが、あと少しで到達しそうな状態
/// を検知する純関数。
/// `OfflineSessionResumeNoticeDismissalStreakDetector`自体は閾値
/// 到達後のみを判定し、到達前の接近状態自体は見ない。実際の「同期が
/// 完了しました」表示方法の見直しはアプリ側の責務とする。
class OfflineSessionResumeNoticeDismissalStreakApproachingDetector {
  const OfflineSessionResumeNoticeDismissalStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveDismissalCount]（直近から連続して無視された同期完了
  /// 案内の回数）が[dismissalThreshold]未満かつ、
  /// [dismissalThreshold] * (1 - [marginRatio])以上であれば、接近状態
  /// と判定する。
  bool isApproaching({
    required int consecutiveDismissalCount,
    required int dismissalThreshold,
  }) {
    if (consecutiveDismissalCount >= dismissalThreshold) {
      return false;
    }
    final marginStart = (dismissalThreshold * (1 - marginRatio)).ceil();
    return consecutiveDismissalCount >= marginStart;
  }
}
