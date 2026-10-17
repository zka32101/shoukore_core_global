import 'guardian_approval_request_queue.dart';

/// 同一の承認対象（単元アンロック等、`payload`が同一内容）に対して、
/// 短時間に複数の承認待ち申請が重複して作成されていないかを検知する純関数。
/// `GuardianApprovalRequestBatchNotice`（承認待ち件数が溜まった場合に
/// まとめ通知すべきかの判定）とは異なり、本クラスは件数の多さではなく
/// 「同じ内容の申請が重複している」こと自体を見る。実際の重複申請の統合・
/// 再送抑制はアプリ側の責務とする。
class GuardianApprovalRequestDuplicateDetector {
  const GuardianApprovalRequestDuplicateDetector({this.duplicateWindow = const Duration(minutes: 10)});

  /// この時間内に作成された、同一payloadの承認待ち申請を重複とみなす。
  final Duration duplicateWindow;

  /// [requests]（承認待ちの申請一覧）のうち、[candidate]と同一の`payload`
  /// を持ち、`requestedAt`の差が[duplicateWindow]以内のものが既に含まれて
  /// いれば重複とみなす。
  bool isDuplicate({
    required GuardianApprovalRequest candidate,
    required Iterable<GuardianApprovalRequest> requests,
  }) {
    return requests.any((request) {
      if (request.id == candidate.id) return false;
      if (!_payloadEquals(request.payload, candidate.payload)) return false;
      return request.requestedAt.difference(candidate.requestedAt).abs() <= duplicateWindow;
    });
  }

  bool _payloadEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (!b.containsKey(entry.key) || b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
