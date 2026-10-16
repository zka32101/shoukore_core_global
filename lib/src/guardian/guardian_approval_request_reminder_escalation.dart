import 'guardian_approval_request_queue.dart';

/// 保護者承認申請（[GuardianApprovalRequest]）が期限切れになる前に、
/// 未処理のままであることをリマインドすべきかを判定する純関数。
/// `GuardianApprovalRequestQueue.isExpired`（既に期限切れかどうかの判定）
/// とは異なり、期限切れ前の事前リードタイムのみを扱う。実際のリマインド
/// 表示・通知送信はアプリ側の責務とする。
class GuardianApprovalRequestReminderEscalation {
  const GuardianApprovalRequestReminderEscalation({
    this.expiresAfter = const Duration(days: 1),
    this.leadTime = const Duration(hours: 4),
  });

  /// 申請から期限切れまでの期間。`GuardianApprovalRequestQueue.expiresAfter`
  /// と同じ値を渡して整合させる想定。
  final Duration expiresAfter;

  /// 期限切れの何時間前からリマインドを出し始めるか。
  final Duration leadTime;

  /// [request]が`pending`のまま、期限切れ前だが[leadTime]以内に迫っている
  /// 場合に`true`を返す。既に`pending`以外、または既に期限切れの場合は
  /// `false`を返す。
  bool shouldEscalate(GuardianApprovalRequest request, DateTime now) {
    if (request.status != GuardianApprovalStatus.pending) return false;
    final expiresAt = request.requestedAt.add(expiresAfter);
    if (now.isAfter(expiresAt)) return false;
    return expiresAt.difference(now) <= leadTime;
  }
}
