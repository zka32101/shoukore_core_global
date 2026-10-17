import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('EntitlementRestoreStalenessNotice', () {
    const notice = EntitlementRestoreStalenessNotice();
    final now = DateTime(2026, 3, 1);

    test('一度も復元していない場合は常に提案すべきと判定する', () {
      expect(notice.shouldSuggestRestore(lastRestoredAt: null, now: now), isTrue);
    });

    test('stalenessPeriodを超えていれば提案すべきと判定する', () {
      final lastRestoredAt = now.subtract(const Duration(days: 31));
      expect(notice.shouldSuggestRestore(lastRestoredAt: lastRestoredAt, now: now), isTrue);
    });

    test('stalenessPeriod以内であれば提案しない', () {
      final lastRestoredAt = now.subtract(const Duration(days: 10));
      expect(notice.shouldSuggestRestore(lastRestoredAt: lastRestoredAt, now: now), isFalse);
    });
  });
}
