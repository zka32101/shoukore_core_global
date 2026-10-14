import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  late InMemoryConsentStore consentStore;
  late _FakeProgressStore progressStore;

  setUp(() {
    consentStore = InMemoryConsentStore();
    progressStore = _FakeProgressStore();
  });

  test('exportUserDataは同意状態と習熟度をまとめて返す', () async {
    final consentedAt = DateTime.utc(2026, 10, 14);
    await consentStore.setConsent(ConsentRecord(
      parentalConsentGiven: true,
      consentedAt: consentedAt,
      policyVersion: 2,
    ));
    progressStore.masteries = [
      Mastery(unitId: 'mat_numeros_1', score: 0.5, lastPracticedAt: consentedAt),
    ];

    final data = await exportUserData(consentStore: consentStore, progressStore: progressStore);

    expect(data['consent'], {
      'parentalConsentGiven': true,
      'consentedAt': consentedAt.toIso8601String(),
      'policyVersion': 2,
    });
    expect(data['progress'], [
      {
        'unitId': 'mat_numeros_1',
        'score': 0.5,
        'lastPracticedAt': consentedAt.toIso8601String(),
      },
    ]);
  });

  test('同意記録が無い場合はconsentがnull', () async {
    final data = await exportUserData(consentStore: consentStore, progressStore: progressStore);
    expect(data['consent'], isNull);
  });

  test('eraseAllUserDataは同意記録と学習記録を両方消す', () async {
    await consentStore.setConsent(const ConsentRecord(parentalConsentGiven: true));
    progressStore.masteries = [const Mastery(unitId: 'mat_numeros_1', score: 1)];

    await eraseAllUserData(consentStore: consentStore, progressStore: progressStore);

    expect(await consentStore.getConsent(), isNull);
    expect(progressStore.cleared, isTrue);
  });
}

class _FakeProgressStore implements ProgressStore {
  List<Mastery> masteries = [];
  bool cleared = false;

  @override
  Future<void> recordAttempt(Attempt attempt) async {}

  @override
  Future<List<Attempt>> getAttempts(String unitId, {int? limit}) async => [];

  @override
  Future<Mastery> getMastery(String unitId) async =>
      Mastery(unitId: unitId, score: 0, lastPracticedAt: null);

  @override
  Future<List<Mastery>> getAllMastery() async => masteries;

  @override
  Future<void> clearAll() async => cleared = true;
}
