/// `ScreenTimeGuardOverrideFrequencyAlert`による利用時間制限の頻繁な
/// 一時解除アラートが連続して無視され続けている状態を検知する純関数。
/// `ScreenTimeGuardOverrideFrequencyAlert`自体は直近の解除頻度のみを見る
/// 単発判定であり、出した後にユーザー（保護者）がどう反応したかは見ない。
/// 実際の「制限の見直しを検討しますか」案内の表示方法の見直しはアプリ
/// 側の責務とする。
class ScreenTimeGuardOverrideFrequencyAlertDismissalStreakDetector {
  const ScreenTimeGuardOverrideFrequencyAlertDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された頻発アラート
  /// の回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
