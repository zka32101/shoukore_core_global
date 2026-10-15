import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const queue = GuardianApprovalRequestQueue(expiresAfter: Duration(days: 1));

  test('承認待ちのまま期限内なら期限切れではない', () {
    final request = GuardianApprovalRequest(
      id: 'r1',
      payload: const {},
      requestedAt: DateTime(2024, 1, 1),
    );
    expect(queue.isExpired(request, DateTime(2024, 1, 1, 12)), isFalse);
  });

  test('承認待ちのまま期限を過ぎたら期限切れ', () {
    final request = GuardianApprovalRequest(
      id: 'r1',
      payload: const {},
      requestedAt: DateTime(2024, 1, 1),
    );
    expect(queue.isExpired(request, DateTime(2024, 1, 3)), isTrue);
  });

  test('承認済みなら期限切れ判定の対象外', () {
    final request = GuardianApprovalRequest(
      id: 'r1',
      payload: const {},
      requestedAt: DateTime(2024, 1, 1),
      status: GuardianApprovalStatus.approved,
    );
    expect(queue.isExpired(request, DateTime(2024, 1, 3)), isFalse);
  });

  test('pendingRequestsは承認待ちかつ未期限のものだけを返す', () {
    final now = DateTime(2024, 1, 1, 12);
    final requests = [
      GuardianApprovalRequest(
        id: 'pending',
        payload: const {},
        requestedAt: DateTime(2024, 1, 1),
      ),
      GuardianApprovalRequest(
        id: 'expired',
        payload: const {},
        requestedAt: DateTime(2023, 12, 1),
      ),
      GuardianApprovalRequest(
        id: 'approved',
        payload: const {},
        requestedAt: DateTime(2024, 1, 1),
        status: GuardianApprovalStatus.approved,
      ),
    ];

    final result = queue.pendingRequests(requests, now);
    expect(result.map((r) => r.id), ['pending']);
  });
}
