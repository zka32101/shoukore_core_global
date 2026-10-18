import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianApprovalRequestBacklogSizeAlert', () {
    const alert = GuardianApprovalRequestBacklogSizeAlert(backlogThreshold: 3);

    GuardianApprovalRequest buildRequest(String id) => GuardianApprovalRequest(
          id: id,
          payload: const {},
          requestedAt: DateTime(2026, 10, 18),
        );

    test('承認待ち件数が閾値以上なら滞留と判定', () {
      final requests = [buildRequest('1'), buildRequest('2'), buildRequest('3')];
      expect(alert.isBacklogged(requests), isTrue);
    });

    test('承認待ち件数が閾値未満なら滞留ではない', () {
      final requests = [buildRequest('1')];
      expect(alert.isBacklogged(requests), isFalse);
    });

    test('承認待ちが0件なら滞留ではない', () {
      expect(alert.isBacklogged(const []), isFalse);
    });
  });
}
