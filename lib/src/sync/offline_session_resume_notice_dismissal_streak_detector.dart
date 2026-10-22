/// `OfflineSessionResumeNotice`による同期完了案内が連続して無視され
/// 続けている状態を検知する純関数。`OfflineSessionResumeNotice`自体は
/// 長時間オフライン後の同期完了のみを見る単発判定であり、出した後に
/// ユーザーがどう反応したかは見ない。実際の「同期が完了しました」表示
/// 方法の見直しはアプリ側の責務とする。
class OfflineSessionResumeNoticeDismissalStreakDetector {
  const OfflineSessionResumeNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された同期完了
  /// 案内の回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
