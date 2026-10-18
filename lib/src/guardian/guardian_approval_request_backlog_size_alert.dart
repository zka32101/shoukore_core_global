import 'guardian_approval_request_queue.dart';

/// 承認待ちの保護者承認申請の件数が一定数を超えて積み上がっている滞留
/// 状態を検知する純関数。`GuardianApprovalRequestQueue`は個々の申請の
/// 期限切れ判定と承認待ち一覧の抽出のみを行うため、件数が積み上がって
/// いるかどうかは見ない。実際の「まとめて確認」案内の表示はアプリ側の
/// 責務とする。
class GuardianApprovalRequestBacklogSizeAlert {
  const GuardianApprovalRequestBacklogSizeAlert({this.backlogThreshold = 5});

  /// 承認待ちの件数がこの数以上になったら滞留とみなす。
  final int backlogThreshold;

  /// [pendingRequests]（承認待ちの申請一覧）の件数が[backlogThreshold]
  /// 以上であれば、滞留状態と判定する。
  bool isBacklogged(List<GuardianApprovalRequest> pendingRequests) {
    return pendingRequests.length >= backlogThreshold;
  }
}
