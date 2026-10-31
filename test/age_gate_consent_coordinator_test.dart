import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const coordinator = AgeGateConsentCoordinator();
  final clock = FixedClock(DateTime(2026, 11, 1));
  const profile = RegionalProfile(
    locale: 'pt_BR',
    ageOfConsent: 12,
    guardianConsentRequired: true,
    dailyResetHour: 5,
    timeZone: 'America/Sao_Paulo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );

  test('同意年齢以上なら、同意不要を記録してfalseを返す', () async {
    final consentStore = InMemoryConsentStore();
    final requires = await coordinator.requiresConsentAndRecordIfNot(
      birthYear: 1990,
      profile: profile,
      clock: clock,
      consentStore: consentStore,
    );
    expect(requires, isFalse);
    final record = await consentStore.getConsent();
    expect(record?.parentalConsentGiven, isFalse);
  });

  test('同意年齢未満なら、何も記録せずtrueを返す', () async {
    final consentStore = InMemoryConsentStore();
    final requires = await coordinator.requiresConsentAndRecordIfNot(
      birthYear: 2020,
      profile: profile,
      clock: clock,
      consentStore: consentStore,
    );
    expect(requires, isTrue);
    expect(await consentStore.getConsent(), isNull);
  });

  test('recordConsentAnswerは回答と時刻を記録する', () async {
    final consentStore = InMemoryConsentStore();
    await coordinator.recordConsentAnswer(
      consentStore: consentStore,
      clock: clock,
      accepted: true,
    );
    final record = await consentStore.getConsent();
    expect(record?.parentalConsentGiven, isTrue);
    expect(record?.consentedAt, clock.now());
  });

  test('recordConsentAnswerで拒否した場合はconsentedAtをnullにする', () async {
    final consentStore = InMemoryConsentStore();
    await coordinator.recordConsentAnswer(
      consentStore: consentStore,
      clock: clock,
      accepted: false,
    );
    final record = await consentStore.getConsent();
    expect(record?.parentalConsentGiven, isFalse);
    expect(record?.consentedAt, isNull);
  });
}
