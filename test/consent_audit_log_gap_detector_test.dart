import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ConsentAuditLogGapDetector', () {
    test('最新イベントから一定期間を超えていれば空白と判定する', () {
      const detector = ConsentAuditLogGapDetector(gapPeriod: Duration(days: 400));
      final entries = [
        ConsentAuditEntry(type: 'granted', occurredAt: DateTime(2025, 1, 1)),
      ];

      final result = detector.hasGap(entries, DateTime(2026, 6, 1));

      expect(result, isTrue);
    });

    test('最新イベントから一定期間未満であれば空白と判定しない', () {
      const detector = ConsentAuditLogGapDetector(gapPeriod: Duration(days: 400));
      final entries = [
        ConsentAuditEntry(type: 'granted', occurredAt: DateTime(2026, 1, 1)),
      ];

      final result = detector.hasGap(entries, DateTime(2026, 3, 1));

      expect(result, isFalse);
    });

    test('履歴が空であれば空白と判定しない', () {
      const detector = ConsentAuditLogGapDetector();

      final result = detector.hasGap([], DateTime(2026, 1, 1));

      expect(result, isFalse);
    });
  });
}
