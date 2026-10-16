import 'guardian_approval_request_queue.dart';

/// 保護者承認待ちの申請が複数件溜まった場合に、個別通知ではなくまとめて
/// 知らせるべきかを判定する純関数。`GuardianNotificationDigestThrottle`
/// （直前の送信からの経過時間のみを見る時間ベースの抑制）とは異なり、
/// 本クラスは承認待ち件数の閾値のみを見る。実際の通知のまとめ・送信
/// 処理はアプリ側の責務とする。
class GuardianApprovalRequestBatchNotice {
  const GuardianApprovalRequestBatchNotice({this.minimumPendingCount = 3});

  /// 承認待ち件数がこれ以上になったらまとめて知らせるべきと判定する。
  final int minimumPendingCount;

  /// [requests]のうち[now]時点で承認待ちのものが[minimumPendingCount]件
  /// 以上であればまとめ通知すべきと判定する。
  bool shouldNotify({
    required Iterable<GuardianApprovalRequest> requests,
    required DateTime now,
    required GuardianApprovalRequestQueue queue,
  }) {
    return queue.pendingRequests(requests, now).length >= minimumPendingCount;
  }
}
