/// `SyncQueueBacklogAlert`による同期キュー滞留アラートが連続して無視
/// され続けている状態を検知する純関数。`SyncQueueBacklogAlert`自体は
/// 未送信アイテムの滞留件数のみを見る単発判定であり、出した後に
/// ユーザーがどう反応したかは見ない。実際の同期不調の調査・案内の
/// 表示方法の見直しはアプリ側の責務とする。
class SyncQueueBacklogAlertDismissalStreakDetector {
  const SyncQueueBacklogAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された同期キュー
  /// 滞留アラートの回数）が[dismissalThreshold]以上であれば、連続無視
  /// 状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
