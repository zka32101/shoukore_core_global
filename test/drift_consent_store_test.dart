import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

void main() {
  late ProgressDatabase db;
  late DriftConsentStore store;

  setUp(() {
    db = ProgressDatabase(NativeDatabase.memory());
    store = DriftConsentStore(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('未設定の場合はnullを返す', () async {
    expect(await store.getConsent(), isNull);
  });

  test('setConsentで記録し、getConsentで取得できる', () async {
    final consentedAt = DateTime.utc(2026, 10, 14);
    await store.setConsent(ConsentRecord(
      parentalConsentGiven: true,
      consentedAt: consentedAt,
      policyVersion: 2,
    ));

    final record = await store.getConsent();
    expect(record!.parentalConsentGiven, isTrue);
    expect(record.consentedAt!.isAtSameMomentAs(consentedAt), isTrue);
    expect(record.policyVersion, 2);
  });

  test('setConsentを2回呼ぶと最新の状態に上書きされる（単一行）', () async {
    await store.setConsent(const ConsentRecord(parentalConsentGiven: true, policyVersion: 1));
    await store.setConsent(const ConsentRecord(parentalConsentGiven: false, policyVersion: 1));

    final record = await store.getConsent();
    expect(record!.parentalConsentGiven, isFalse);
  });

  test('revokeConsentで記録が消え、getConsentはnullを返す', () async {
    await store.setConsent(const ConsentRecord(parentalConsentGiven: true));
    await store.revokeConsent();
    expect(await store.getConsent(), isNull);
  });

  test('eraseAllで記録が消える（LGPD削除要求対応）', () async {
    await store.setConsent(const ConsentRecord(parentalConsentGiven: true));
    await store.eraseAll();
    expect(await store.getConsent(), isNull);
  });
}
