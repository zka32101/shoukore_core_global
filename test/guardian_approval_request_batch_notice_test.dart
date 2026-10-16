import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = GuardianApprovalRequestBatchNotice(minimumPendingCount: 3);
  const queue = GuardianApprovalRequestQueue();
  final now = DateTime(2024, 1, 1);

  GuardianApprovalRequest pending(String id) => GuardianApprovalRequest(
        id: id,
        payload: const {},
        requestedAt: now,
      );

  test('承認待ちが閾値未満ならまとめ通知しない', () {
    expect(
      notice.shouldNotify(requests: [pending('a'), pending('b')], now: now, queue: queue),
      isFalse,
    );
  });

  test('承認待ちが閾値以上ならまとめ通知する', () {
    expect(
      notice.shouldNotify(
        requests: [pending('a'), pending('b'), pending('c')],
        now: now,
        queue: queue,
      ),
      isTrue,
    );
  });

  test('承認済み・却下済みは件数に数えない', () {
    final requests = [
      pending('a'),
      pending('b'),
      pending('c').withStatus(GuardianApprovalStatus.approved),
    ];
    expect(
      notice.shouldNotify(requests: requests, now: now, queue: queue),
      isFalse,
    );
  });
}
