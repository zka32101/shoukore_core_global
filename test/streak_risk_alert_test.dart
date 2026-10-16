import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const profile = RegionalProfile(
    locale: 'ja',
    ageOfConsent: 13,
    guardianConsentRequired: true,
    dailyResetHour: 5,
    timeZone: 'Asia/Tokyo',
    screenTimeLimitMinutes: 60,
    profilingAdsAllowed: false,
  );
  final boundary = DailyBoundary(profile);
  const alert = StreakRiskAlert(remainingTimeThreshold: Duration(hours: 2));

  test('今日既に学習済みならアラートしない', () {
    expect(
      alert.shouldAlert(
        lastStudiedDay: DateTime(2024, 1, 1, 8),
        now: DateTime(2024, 1, 1, 10),
        boundary: boundary,
      ),
      isFalse,
    );
  });

  test('今日未学習だが残り時間が十分あればアラートしない', () {
    expect(
      alert.shouldAlert(
        lastStudiedDay: DateTime(2023, 12, 31, 8),
        now: DateTime(2024, 1, 1, 10),
        boundary: boundary,
      ),
      isFalse,
    );
  });

  test('今日未学習で残り時間が少なければアラートする', () {
    expect(
      alert.shouldAlert(
        lastStudiedDay: DateTime(2023, 12, 31, 8),
        now: DateTime(2024, 1, 2, 3, 30),
        boundary: boundary,
      ),
      isTrue,
    );
  });
}
