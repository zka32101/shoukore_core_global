import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

RegionalProfile _profile({int screenTimeLimitMinutes = 60}) => RegionalProfile(
      locale: 'ja',
      ageOfConsent: 13,
      guardianConsentRequired: true,
      dailyResetHour: 5,
      timeZone: 'Asia/Tokyo',
      screenTimeLimitMinutes: screenTimeLimitMinutes,
      profilingAdsAllowed: false,
    );

void main() {
  group('RegionalProfileChangeDetector', () {
    test('内容が変わっていれば変化ありと判定する', () {
      const detector = RegionalProfileChangeDetector();

      final result = detector.hasChanged(
        cached: _profile(screenTimeLimitMinutes: 60),
        latest: _profile(screenTimeLimitMinutes: 90),
      );

      expect(result, isTrue);
    });

    test('内容が同じであれば変化なしと判定する', () {
      const detector = RegionalProfileChangeDetector();

      final result = detector.hasChanged(
        cached: _profile(),
        latest: _profile(),
      );

      expect(result, isFalse);
    });

    test('キャッシュがなければ変化なしと判定する', () {
      const detector = RegionalProfileChangeDetector();

      final result = detector.hasChanged(cached: null, latest: _profile());

      expect(result, isFalse);
    });
  });
}
