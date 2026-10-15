import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const policy = ConsentExpiryPolicy(
    validity: Duration(days: 365),
    currentPolicyVersion: 2,
  );

  group('isExpired', () {
    test('同意していなければ期限切れとして扱う', () {
      const record = ConsentRecord(parentalConsentGiven: false);
      expect(policy.isExpired(record, DateTime(2024, 1, 1)), isTrue);
    });

    test('consentedAtが未設定なら期限切れとして扱う', () {
      const record = ConsentRecord(parentalConsentGiven: true);
      expect(policy.isExpired(record, DateTime(2024, 1, 1)), isTrue);
    });

    test('有効期間内はfalse', () {
      final record = ConsentRecord(
        parentalConsentGiven: true,
        consentedAt: DateTime(2024, 1, 1),
        policyVersion: 2,
      );
      expect(policy.isExpired(record, DateTime(2024, 6, 1)), isFalse);
    });

    test('有効期間を超えればtrue', () {
      final record = ConsentRecord(
        parentalConsentGiven: true,
        consentedAt: DateTime(2024, 1, 1),
        policyVersion: 2,
      );
      expect(policy.isExpired(record, DateTime(2025, 1, 2)), isTrue);
    });
  });

  group('needsReconfirmation', () {
    test('期限切れなら再同意が必要', () {
      final record = ConsentRecord(
        parentalConsentGiven: true,
        consentedAt: DateTime(2024, 1, 1),
        policyVersion: 2,
      );
      expect(policy.needsReconfirmation(record, DateTime(2025, 1, 2)), isTrue);
    });

    test('期限内でもポリシーバージョンが古ければ再同意が必要', () {
      final record = ConsentRecord(
        parentalConsentGiven: true,
        consentedAt: DateTime(2024, 1, 1),
        policyVersion: 1,
      );
      expect(policy.needsReconfirmation(record, DateTime(2024, 6, 1)), isTrue);
    });

    test('期限内かつ最新ポリシーバージョンならfalse', () {
      final record = ConsentRecord(
        parentalConsentGiven: true,
        consentedAt: DateTime(2024, 1, 1),
        policyVersion: 2,
      );
      expect(policy.needsReconfirmation(record, DateTime(2024, 6, 1)), isFalse);
    });
  });
}
