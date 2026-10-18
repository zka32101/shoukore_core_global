import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('DataExportRenewalNotice', () {
    const notice = DataExportRenewalNotice();
    final now = DateTime(2026, 6, 1);

    test('一度も書き出していない場合は提案しない', () {
      expect(notice.shouldSuggestRenewal(lastExportedAt: null, now: now), isFalse);
    });

    test('stalenessPeriodを超えていれば提案すべきと判定する', () {
      final lastExportedAt = now.subtract(const Duration(days: 181));
      expect(notice.shouldSuggestRenewal(lastExportedAt: lastExportedAt, now: now), isTrue);
    });

    test('stalenessPeriod以内であれば提案しない', () {
      final lastExportedAt = now.subtract(const Duration(days: 30));
      expect(notice.shouldSuggestRenewal(lastExportedAt: lastExportedAt, now: now), isFalse);
    });
  });
}
