import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('exportSettingsBackup/importSettingsBackup', () {
    test('同意状態・プロファイル一覧・アクティブプロファイルをまとめて書き出す', () async {
      final consentStore = InMemoryConsentStore();
      final profileStore = InMemoryProfileStore();
      await consentStore.setConsent(ConsentRecord(
        parentalConsentGiven: true,
        consentedAt: DateTime.utc(2026, 10, 1),
        policyVersion: 2,
      ));
      await profileStore.saveProfile(const Profile(id: 'p1', displayName: 'たろう', birthYear: 2018));
      await profileStore.setActiveProfileId('p1');

      final backup = await exportSettingsBackup(
        consentStore: consentStore,
        profileStore: profileStore,
      );

      expect(backup['consent'], {
        'parentalConsentGiven': true,
        'consentedAt': DateTime.utc(2026, 10, 1).toIso8601String(),
        'policyVersion': 2,
      });
      expect(backup['profiles'], [
        {'id': 'p1', 'displayName': 'たろう', 'birthYear': 2018},
      ]);
      expect(backup['activeProfileId'], 'p1');
    });

    test('書き出した内容をimportで別のStoreに復元できる', () async {
      final sourceConsent = InMemoryConsentStore();
      final sourceProfiles = InMemoryProfileStore();
      await sourceConsent.setConsent(const ConsentRecord(parentalConsentGiven: true));
      await sourceProfiles.saveProfile(const Profile(id: 'p1', displayName: 'たろう'));
      await sourceProfiles.setActiveProfileId('p1');

      final backup = await exportSettingsBackup(
        consentStore: sourceConsent,
        profileStore: sourceProfiles,
      );

      final targetConsent = InMemoryConsentStore();
      final targetProfiles = InMemoryProfileStore();
      await importSettingsBackup(
        backup,
        consentStore: targetConsent,
        profileStore: targetProfiles,
      );

      final consent = await targetConsent.getConsent();
      expect(consent!.parentalConsentGiven, isTrue);
      final profiles = await targetProfiles.listProfiles();
      expect(profiles.single.id, 'p1');
      expect(await targetProfiles.getActiveProfileId(), 'p1');
    });

    test('JSON文字列経由でも往復できる', () async {
      final sourceConsent = InMemoryConsentStore();
      final sourceProfiles = InMemoryProfileStore();
      await sourceConsent.setConsent(const ConsentRecord(parentalConsentGiven: false));
      await sourceProfiles.saveProfile(const Profile(id: 'p1', displayName: 'はなこ'));

      final json = await exportSettingsBackupAsJson(
        consentStore: sourceConsent,
        profileStore: sourceProfiles,
      );

      final targetConsent = InMemoryConsentStore();
      final targetProfiles = InMemoryProfileStore();
      await importSettingsBackupFromJson(
        json,
        consentStore: targetConsent,
        profileStore: targetProfiles,
      );

      final consent = await targetConsent.getConsent();
      expect(consent!.parentalConsentGiven, isFalse);
      expect((await targetProfiles.listProfiles()).single.displayName, 'はなこ');
    });

    test('consentが未記録の場合はimportしても何もしない', () async {
      final sourceConsent = InMemoryConsentStore();
      final sourceProfiles = InMemoryProfileStore();
      await sourceProfiles.saveProfile(const Profile(id: 'p1', displayName: 'たろう'));

      final backup = await exportSettingsBackup(
        consentStore: sourceConsent,
        profileStore: sourceProfiles,
      );

      final targetConsent = InMemoryConsentStore();
      final targetProfiles = InMemoryProfileStore();
      await importSettingsBackup(
        backup,
        consentStore: targetConsent,
        profileStore: targetProfiles,
      );

      expect(await targetConsent.getConsent(), isNull);
      expect((await targetProfiles.listProfiles()).single.id, 'p1');
    });
  });
}
