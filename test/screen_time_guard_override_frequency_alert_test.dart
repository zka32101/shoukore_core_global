import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ScreenTimeGuardOverrideFrequencyAlert', () {
    test('期間内の解除回数が閾値以上であれば頻発と判定する', () {
      const alert = ScreenTimeGuardOverrideFrequencyAlert(
        window: Duration(days: 7),
        overrideThreshold: 3,
      );
      final now = DateTime(2026, 1, 10);

      final result = alert.isFrequentlyOverridden(
        overrideTimestamps: [
          DateTime(2026, 1, 8),
          DateTime(2026, 1, 9),
          DateTime(2026, 1, 9, 12),
        ],
        now: now,
      );

      expect(result, isTrue);
    });

    test('期間内の解除回数が閾値未満であれば頻発と判定しない', () {
      const alert = ScreenTimeGuardOverrideFrequencyAlert(
        window: Duration(days: 7),
        overrideThreshold: 3,
      );
      final now = DateTime(2026, 1, 10);

      final result = alert.isFrequentlyOverridden(
        overrideTimestamps: [DateTime(2026, 1, 9)],
        now: now,
      );

      expect(result, isFalse);
    });

    test('期間外の解除は件数に含めない', () {
      const alert = ScreenTimeGuardOverrideFrequencyAlert(
        window: Duration(days: 7),
        overrideThreshold: 2,
      );
      final now = DateTime(2026, 1, 10);

      final result = alert.isFrequentlyOverridden(
        overrideTimestamps: [DateTime(2025, 12, 1), DateTime(2026, 1, 9)],
        now: now,
      );

      expect(result, isFalse);
    });
  });
}
