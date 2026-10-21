/// `GuardianApprovalRequestBatchNotice`による承認待ちまとめ通知が連続
/// して無視され続けている状態を検知する純関数。
/// `GuardianApprovalRequestBatchNotice`自体は承認待ち件数のみを見る単発
/// 判定であり、出した後にユーザーがどう反応したかは見ない。実際の表示
/// 方法の見直し案内はアプリ側の責務とする。
class GuardianApprovalRequestBatchNoticeDismissalStreakDetector {
  const GuardianApprovalRequestBatchNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視されたまとめ通知の
  /// 回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
