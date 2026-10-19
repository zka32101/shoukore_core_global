import 'guardian_approval_request_queue.dart';

/// 保護者承認申請（[GuardianApprovalRequest]）が連続して却下され続けている
/// 状態を検知する純関数。`GuardianApprovalRequestStaleRejectionReminder`は
/// 1件の却下後に再申請がないまま放置されている期間のみを見るため、複数
/// 申請にわたって却下が連続しているかは見ない。`GuardianApprovalRequestQueue`
/// 自体は申請単体の期限切れ判定のみを行う。実際の再申請制限・案内表示は
/// アプリ側の責務とする。
class GuardianApprovalRequestRepeatedRejectionStreakDetector {
  const GuardianApprovalRequestRepeatedRejectionStreakDetector({
    this.rejectionThreshold = 3,
  });

  /// 連続却下がこの回数以上になったら検知対象とみなす。
  final int rejectionThreshold;

  /// [consecutiveRejectionCount]（直近から連続して却下された申請の回数）
  /// が[rejectionThreshold]以上であれば、連続却下状態と判定する。
  bool isRepeatedlyRejected(int consecutiveRejectionCount) {
    return consecutiveRejectionCount >= rejectionThreshold;
  }
}
