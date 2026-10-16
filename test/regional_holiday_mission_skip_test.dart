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
  const skip = RegionalHolidayMissionSkip();

  test('祝日リストに含まれる日はスキップ対象', () {
    final holidays = {DateTime(2024, 1, 1)};
    expect(
      skip.isSkippable(now: DateTime(2024, 1, 1, 15), boundary: boundary, holidays: holidays),
      isTrue,
    );
  });

  test('祝日リストに含まれない日はスキップ対象外', () {
    final holidays = {DateTime(2024, 1, 1)};
    expect(
      skip.isSkippable(now: DateTime(2024, 1, 2), boundary: boundary, holidays: holidays),
      isFalse,
    );
  });

  test('祝日リストが空ならスキップ対象外', () {
    expect(
      skip.isSkippable(now: DateTime(2024, 1, 1), boundary: boundary, holidays: const {}),
      isFalse,
    );
  });
}
