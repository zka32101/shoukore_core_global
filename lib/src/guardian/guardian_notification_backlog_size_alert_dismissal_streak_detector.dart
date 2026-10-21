/// `GuardianNotificationBacklogSizeAlert`による保護者向け通知積み上がり
/// アラートが連続して無視され続けている状態を検知する純関数。
/// `GuardianNotificationBacklogSizeAlert`自体は抑制済み通知件数のみを見る
/// 単発判定であり、出した後にユーザーがどう反応したかは見ない。実際の
/// まとめ送り処理の実行判断の見直しはアプリ側の責務とする。
class GuardianNotificationBacklogSizeAlertDismissalStreakDetector {
  const GuardianNotificationBacklogSizeAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された積み上がり
  /// アラートの回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
