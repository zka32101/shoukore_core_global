import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

GuardianApprovalRequest _request(DateTime requestedAt, {GuardianApprovalStatus status = GuardianApprovalStatus.pending}) =>
    GuardianApprovalRequest(
      id: 'req-1',
      payload: const {},
      requestedAt: requestedAt,
      status: status,
    );

void main() {
  const escalation = GuardianApprovalRequestReminderEscalation(
    expiresAfter: Duration(days: 1),
    leadTime: Duration(hours: 4),
  );

  test('期限まで十分余裕があればリマインドしない', () {
    final request = _request(DateTime(2024, 1, 1, 0));
    expect(escalation.shouldEscalate(request, DateTime(2024, 1, 1, 10)), isFalse);
  });

  test('期限切れ直前（リードタイム以内）ならリマインドする', () {
    final request = _request(DateTime(2024, 1, 1, 0));
    expect(escalation.shouldEscalate(request, DateTime(2024, 1, 1, 21)), isTrue);
  });

  test('既に期限切れならリマインドしない', () {
    final request = _request(DateTime(2024, 1, 1, 0));
    expect(escalation.shouldEscalate(request, DateTime(2024, 1, 2, 1)), isFalse);
  });

  test('pending以外の状態ならリマインドしない', () {
    final request = _request(DateTime(2024, 1, 1, 0), status: GuardianApprovalStatus.approved);
    expect(escalation.shouldEscalate(request, DateTime(2024, 1, 1, 21)), isFalse);
  });
}
