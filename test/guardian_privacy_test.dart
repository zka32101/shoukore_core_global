import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianGate', () {
    test('生成したチャレンジは必ず乗算の答えで検証できる', () {
      final gate = GuardianGate();
      for (var i = 0; i < 50; i++) {
        final challenge = gate.generateChallenge();
        expect(challenge.a, inInclusiveRange(10, 99));
        expect(challenge.b, inInclusiveRange(10, 99));
        expect(gate.verify(challenge, challenge.a * challenge.b), isTrue);
        expect(gate.verify(challenge, challenge.a * challenge.b + 1), isFalse);
      }
    });
  });

  group('ScreenTimeGuard', () {
    const profile = RegionalProfile(
      locale: 'pt_BR',
      ageOfConsent: 12,
      guardianConsentRequired: true,
      dailyResetHour: 0,
      timeZone: 'America/Sao_Paulo',
      screenTimeLimitMinutes: 60,
      profilingAdsAllowed: false,
    );

    test('制限時間を超えたら isOverLimit が true になる', () {
      const guard = ScreenTimeGuard(profile);
      expect(guard.isOverLimit(const Duration(minutes: 61)), isTrue);
      expect(guard.isOverLimit(const Duration(minutes: 30)), isFalse);
    });

    test('screenTimeLimitMinutes が 0 の地域は無制限', () {
      const unlimited = RegionalProfile(
        locale: 'ja',
        ageOfConsent: 16,
        guardianConsentRequired: false,
        dailyResetHour: 5,
        timeZone: 'Asia/Tokyo',
        screenTimeLimitMinutes: 0,
        profilingAdsAllowed: false,
      );
      const guard = ScreenTimeGuard(unlimited);
      expect(guard.isLimited, isFalse);
      expect(guard.isOverLimit(const Duration(hours: 10)), isFalse);
    });
  });

  group('AgeGate', () {
    const ptProfile = RegionalProfile(
      locale: 'pt_BR',
      ageOfConsent: 12,
      guardianConsentRequired: true,
      dailyResetHour: 0,
      timeZone: 'America/Sao_Paulo',
      screenTimeLimitMinutes: 0,
      profilingAdsAllowed: false,
    );

    test('同意年齢未満なら保護者同意が必要', () {
      const gate = AgeGate();
      final clock = FixedClock(DateTime.utc(2026, 10, 14));
      final required = gate.requiresGuardianConsent(
        birthYear: 2018,
        profile: ptProfile,
        clock: clock,
      );
      expect(required, isTrue);
    });

    test('同意年齢以上なら保護者同意は不要', () {
      const gate = AgeGate();
      final clock = FixedClock(DateTime.utc(2026, 10, 14));
      final required = gate.requiresGuardianConsent(
        birthYear: 2005,
        profile: ptProfile,
        clock: clock,
      );
      expect(required, isFalse);
    });

    test('guardianConsentRequired が false の地域は常に不要', () {
      const jaProfile = RegionalProfile(
        locale: 'ja',
        ageOfConsent: 16,
        guardianConsentRequired: false,
        dailyResetHour: 5,
        timeZone: 'Asia/Tokyo',
        screenTimeLimitMinutes: 0,
        profilingAdsAllowed: false,
      );
      const gate = AgeGate();
      final clock = FixedClock(DateTime.utc(2026, 10, 14));
      final required = gate.requiresGuardianConsent(
        birthYear: 2018,
        profile: jaProfile,
        clock: clock,
      );
      expect(required, isFalse);
    });
  });

  group('InMemoryConsentStore', () {
    test('同意を記録・取得・取消できる', () async {
      final store = InMemoryConsentStore();
      expect(await store.getConsent(), isNull);

      await store.setConsent(const ConsentRecord(parentalConsentGiven: true));
      final record = await store.getConsent();
      expect(record!.parentalConsentGiven, isTrue);

      await store.revokeConsent();
      expect(await store.getConsent(), isNull);
    });

    test('eraseAll で削除要求に対応する（LGPD権利行使）', () async {
      final store = InMemoryConsentStore();
      await store.setConsent(const ConsentRecord(parentalConsentGiven: true));
      await store.eraseAll();
      expect(await store.getConsent(), isNull);
    });
  });
}
