import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const profile = RegionalProfile(
    locale: 'ja',
    ageOfConsent: 16,
    guardianConsentRequired: false,
    dailyResetHour: 0,
    timeZone: 'Asia/Tokyo',
    screenTimeLimitMinutes: 60,
    profilingAdsAllowed: false,
  );
  const guard = ScreenTimeGuard(profile);
  const warning = ScreenTimeWarningThreshold(warnAtRemainingRatio: 0.1);

  test('残り時間が十分あれば警告しない', () {
    expect(warning.shouldWarn(guard, const Duration(minutes: 10)), isFalse);
  });

  test('残り時間が閾値以下なら警告する', () {
    expect(warning.shouldWarn(guard, const Duration(minutes: 55)), isTrue);
  });

  test('既に制限超過なら警告しない', () {
    expect(warning.shouldWarn(guard, const Duration(minutes: 60)), isFalse);
  });

  test('制限なしのプロファイルでは警告しない', () {
    const unlimited = RegionalProfile(
      locale: 'ja',
      ageOfConsent: 16,
      guardianConsentRequired: false,
      dailyResetHour: 0,
      timeZone: 'Asia/Tokyo',
      screenTimeLimitMinutes: 0,
      profilingAdsAllowed: false,
    );
    final unlimitedGuard = ScreenTimeGuard(unlimited);
    expect(warning.shouldWarn(unlimitedGuard, const Duration(minutes: 999)), isFalse);
  });
}
