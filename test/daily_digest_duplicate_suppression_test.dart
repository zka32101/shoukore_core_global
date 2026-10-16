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
  const suppression = DailyDigestDuplicateSuppression();

  test('未送信（lastSentDayがnull）なら抑制しない', () {
    expect(
      suppression.shouldSuppress(
        lastSentDay: null,
        targetDay: DateTime(2024, 1, 1, 10),
        boundary: boundary,
      ),
      isFalse,
    );
  });

  test('同じミッション日に既に送信済みなら抑制する', () {
    expect(
      suppression.shouldSuppress(
        lastSentDay: DateTime(2024, 1, 1, 10),
        targetDay: DateTime(2024, 1, 1, 20),
        boundary: boundary,
      ),
      isTrue,
    );
  });

  test('異なるミッション日なら抑制しない', () {
    expect(
      suppression.shouldSuppress(
        lastSentDay: DateTime(2024, 1, 1, 10),
        targetDay: DateTime(2024, 1, 2, 10),
        boundary: boundary,
      ),
      isFalse,
    );
  });
}
