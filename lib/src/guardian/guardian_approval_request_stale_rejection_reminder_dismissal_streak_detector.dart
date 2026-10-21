/// `GuardianApprovalRequestStaleRejectionReminder`による却下後の再提出
/// 案内が連続して無視され続けている状態を検知する純関数。
/// `GuardianApprovalRequestStaleRejectionReminder`自体は却下後の経過時間
/// のみを見る単発判定であり、出した後にユーザーがどう反応したかは見ない。
/// 実際の表示方法の見直し案内はアプリ側の責務とする。
class GuardianApprovalRequestStaleRejectionReminderDismissalStreakDetector {
  const GuardianApprovalRequestStaleRejectionReminderDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された再提出案内の
  /// 回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
