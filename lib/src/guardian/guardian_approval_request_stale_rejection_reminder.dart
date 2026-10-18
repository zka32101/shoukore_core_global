import 'guardian_approval_request_queue.dart';

/// 保護者が「却下」した承認申請が、その後長期間再提出されずに放置されて
/// いる状態を検知する純関数。`GuardianApprovalRequestReminderEscalation`は
/// 未処理（`pending`）の申請が期限切れに近づいていることのみを見るため、
/// 却下後に何も起きていない状態は見ない。`GuardianApprovalRequestBacklogSizeAlert`
/// は承認待ちの件数の積み上がりのみを見るため、却下後の放置は見ない。
/// 実際の再提出案内の表示はアプリ側の責務とする。
class GuardianApprovalRequestStaleRejectionReminder {
  const GuardianApprovalRequestStaleRejectionReminder({
    this.staleAfter = const Duration(days: 7),
  });

  /// 却下からこの期間を超えて再提出がなければ放置とみなす。
  final Duration staleAfter;

  /// [request]が`rejected`のまま、却下時刻（[rejectedAt]）から[staleAfter]
  /// を超えて経過している場合に`true`を返す。`rejected`以外の状態の場合は
  /// `false`を返す。
  bool isStaleRejection({
    required GuardianApprovalRequest request,
    required DateTime rejectedAt,
    required DateTime now,
  }) {
    if (request.status != GuardianApprovalStatus.rejected) return false;
    return now.difference(rejectedAt) > staleAfter;
  }
}
