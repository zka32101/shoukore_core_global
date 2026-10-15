/// 保護者承認申請1件の状態。
enum GuardianApprovalStatus { pending, approved, rejected, expired }

/// 子がコイン使用・ストア購入等を試みた際の保護者承認申請。
/// 内容（何を承認してほしいか）はアプリ側が決める任意のMapとし、本コアは
/// 申請の状態（承認待ち・承認済み・却下・期限切れ）の判定のみを担う。
class GuardianApprovalRequest {
  const GuardianApprovalRequest({
    required this.id,
    required this.payload,
    required this.requestedAt,
    this.status = GuardianApprovalStatus.pending,
  });

  final String id;
  final Map<String, dynamic> payload;
  final DateTime requestedAt;
  final GuardianApprovalStatus status;

  GuardianApprovalRequest withStatus(GuardianApprovalStatus newStatus) =>
      GuardianApprovalRequest(
        id: id,
        payload: payload,
        requestedAt: requestedAt,
        status: newStatus,
      );
}

/// `GuardianGate`（即時PINによる計算チャレンジ）とは別に、保護者が後から
/// 確認・承認/却下する非同期の申請フローを扱う純関数モジュール。申請の
/// 永続化・実際の通知送信はアプリ側の責務とし、本コアは期限切れ判定と
/// 承認待ち一覧の抽出のみを提供する。
class GuardianApprovalRequestQueue {
  const GuardianApprovalRequestQueue({this.expiresAfter = const Duration(days: 1)});

  /// 申請から承認/却下がないままこの期間が過ぎると期限切れとみなす。
  final Duration expiresAfter;

  /// [request]が[now]時点で期限切れであれば`true`を返す
  /// （statusが`pending`のままexpiresAfterを超えた場合のみ）。
  bool isExpired(GuardianApprovalRequest request, DateTime now) {
    if (request.status != GuardianApprovalStatus.pending) return false;
    return now.difference(request.requestedAt) > expiresAfter;
  }

  /// [requests]のうち、[now]時点でまだ承認待ち（期限切れを除く）のものを返す。
  List<GuardianApprovalRequest> pendingRequests(
    Iterable<GuardianApprovalRequest> requests,
    DateTime now,
  ) {
    return requests
        .where((r) => r.status == GuardianApprovalStatus.pending && !isExpired(r, now))
        .toList();
  }
}
