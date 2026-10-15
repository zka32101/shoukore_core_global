import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const profile = RegionalProfile(
    locale: 'ja',
    ageOfConsent: 16,
    guardianConsentRequired: false,
    dailyResetHour: 0,
    timeZone: 'Asia/Tokyo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );
  const boundary = DailyBoundary(profile);
  const grace = StreakRecoveryGrace(graceDays: 1);

  test('最終学習日がnullなら対象外', () {
    expect(
      grace.isRecoverable(lastStudiedDay: null, now: DateTime(2024, 1, 3), boundary: boundary),
      isFalse,
    );
  });

  test('連続（翌日）の場合は対象外（通常のストリーク継続）', () {
    expect(
      grace.isRecoverable(
        lastStudiedDay: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 2),
        boundary: boundary,
      ),
      isFalse,
    );
  });

  test('1日見逃し（2日空き）はgraceDays=1なら対象', () {
    expect(
      grace.isRecoverable(
        lastStudiedDay: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 3),
        boundary: boundary,
      ),
      isTrue,
    );
  });

  test('graceDaysを超えた間隔は対象外', () {
    expect(
      grace.isRecoverable(
        lastStudiedDay: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 5),
        boundary: boundary,
      ),
      isFalse,
    );
  });
}
