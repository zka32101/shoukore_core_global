import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ProfilePhotoConsentRenewalNotice', () {
    const notice = ProfilePhotoConsentRenewalNotice();
    final now = DateTime(2026, 6, 1);

    test('同意がnullの場合は提案しない', () {
      expect(notice.shouldSuggestRenewal(consent: null, now: now), isFalse);
    });

    test('同意が取り消されている場合は提案しない', () {
      final consent = ProfilePhotoConsent(
        granted: false,
        grantedAt: now.subtract(const Duration(days: 400)),
      );
      expect(notice.shouldSuggestRenewal(consent: consent, now: now), isFalse);
    });

    test('同意取得からstalenessPeriodを超えていれば提案すべきと判定する', () {
      final consent = ProfilePhotoConsent(
        granted: true,
        grantedAt: now.subtract(const Duration(days: 400)),
      );
      expect(notice.shouldSuggestRenewal(consent: consent, now: now), isTrue);
    });

    test('同意取得からstalenessPeriod以内であれば提案しない', () {
      final consent = ProfilePhotoConsent(
        granted: true,
        grantedAt: now.subtract(const Duration(days: 30)),
      );
      expect(notice.shouldSuggestRenewal(consent: consent, now: now), isFalse);
    });
  });
}
