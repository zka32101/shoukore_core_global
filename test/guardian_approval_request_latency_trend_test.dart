import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianApprovalRequestLatencyTrend', () {
    const trend = GuardianApprovalRequestLatencyTrend(
      recentWindowSize: 2,
      worseningRatioThreshold: 1.5,
    );

    test('直近の応答時間が大幅に悪化していれば悪化傾向と判定', () {
      final latencies = [
        const Duration(minutes: 10),
        const Duration(minutes: 10),
        const Duration(minutes: 30),
        const Duration(minutes: 30),
      ];
      expect(trend.isWorsening(latencies), isTrue);
    });

    test('応答時間がほぼ一定であれば悪化傾向ではない', () {
      final latencies = [
        const Duration(minutes: 10),
        const Duration(minutes: 10),
        const Duration(minutes: 11),
        const Duration(minutes: 11),
      ];
      expect(trend.isWorsening(latencies), isFalse);
    });

    test('比較に十分な件数がなければ悪化傾向ではない', () {
      final latencies = [const Duration(minutes: 10), const Duration(minutes: 30)];
      expect(trend.isWorsening(latencies), isFalse);
    });
  });
}
