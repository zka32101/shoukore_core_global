import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianApprovalRequestStaleRejectionReminder', () {
    test('却下から一定期間を超えて再提出がなければ放置と判定する', () {
      const reminder = GuardianApprovalRequestStaleRejectionReminder(
        staleAfter: Duration(days: 7),
      );
      final rejectedAt = DateTime(2026, 1, 1);
      final now = DateTime(2026, 1, 10);
      final request = GuardianApprovalRequest(
        id: 'req1',
        payload: const {},
        requestedAt: rejectedAt,
      ).withStatus(GuardianApprovalStatus.rejected);

      final result = reminder.isStaleRejection(
        request: request,
        rejectedAt: rejectedAt,
        now: now,
      );

      expect(result, isTrue);
    });

    test('却下から一定期間未満であれば放置と判定しない', () {
      const reminder = GuardianApprovalRequestStaleRejectionReminder(
        staleAfter: Duration(days: 7),
      );
      final rejectedAt = DateTime(2026, 1, 1);
      final now = DateTime(2026, 1, 3);
      final request = GuardianApprovalRequest(
        id: 'req1',
        payload: const {},
        requestedAt: rejectedAt,
      ).withStatus(GuardianApprovalStatus.rejected);

      final result = reminder.isStaleRejection(
        request: request,
        rejectedAt: rejectedAt,
        now: now,
      );

      expect(result, isFalse);
    });

    test('却下以外の状態であれば放置と判定しない', () {
      const reminder = GuardianApprovalRequestStaleRejectionReminder();
      final requestedAt = DateTime(2026, 1, 1);
      final now = DateTime(2026, 2, 1);
      final request = GuardianApprovalRequest(
        id: 'req1',
        payload: const {},
        requestedAt: requestedAt,
      );

      final result = reminder.isStaleRejection(
        request: request,
        rejectedAt: requestedAt,
        now: now,
      );

      expect(result, isFalse);
    });
  });
}
