import 'dart:convert';

import '../models/models.dart';
import '../profile/profile.dart';
import '../profile/profile_store.dart';
import 'consent_store.dart';

/// 端末移行時に保護者が引き継ぎたい設定（同意状態・プロファイル一覧・
/// 選択中プロファイル）をまとめてバックアップする。学習記録（`Attempt`/
/// `Mastery`）は[exportUserData]が別途担うため、ここでは含めない。
/// 実際のファイル保存・共有・新端末への転送方法はアプリ側の責務。
Future<Map<String, dynamic>> exportSettingsBackup({
  required ConsentStore consentStore,
  required ProfileStore profileStore,
}) async {
  final consent = await consentStore.getConsent();
  final profiles = await profileStore.listProfiles();
  final activeProfileId = await profileStore.getActiveProfileId();

  return {
    'consent': consent == null
        ? null
        : {
            'parentalConsentGiven': consent.parentalConsentGiven,
            'consentedAt': consent.consentedAt?.toIso8601String(),
            'policyVersion': consent.policyVersion,
          },
    'profiles': [
      for (final profile in profiles)
        {
          'id': profile.id,
          'displayName': profile.displayName,
          'birthYear': profile.birthYear,
        },
    ],
    'activeProfileId': activeProfileId,
  };
}

/// [exportSettingsBackup]の結果をJSON文字列化する。
Future<String> exportSettingsBackupAsJson({
  required ConsentStore consentStore,
  required ProfileStore profileStore,
}) async {
  final data = await exportSettingsBackup(
    consentStore: consentStore,
    profileStore: profileStore,
  );
  return const JsonEncoder.withIndent('  ').convert(data);
}

/// [exportSettingsBackup]が出力したデータを復元する。既存の同意・プロファイル
/// 状態は上書きされる（`ConsentStore.setConsent`/`ProfileStore.saveProfile`は
/// いずれも上書き操作）。
Future<void> importSettingsBackup(
  Map<String, dynamic> data, {
  required ConsentStore consentStore,
  required ProfileStore profileStore,
}) async {
  final consentData = data['consent'] as Map<String, dynamic>?;
  if (consentData != null) {
    await consentStore.setConsent(ConsentRecord(
      parentalConsentGiven: consentData['parentalConsentGiven'] as bool,
      consentedAt: consentData['consentedAt'] == null
          ? null
          : DateTime.parse(consentData['consentedAt'] as String),
      policyVersion: consentData['policyVersion'] as int,
    ));
  }

  final profilesData = data['profiles'] as List<dynamic>? ?? const [];
  for (final raw in profilesData) {
    final profileData = raw as Map<String, dynamic>;
    await profileStore.saveProfile(Profile(
      id: profileData['id'] as String,
      displayName: profileData['displayName'] as String,
      birthYear: profileData['birthYear'] as int?,
    ));
  }

  final activeProfileId = data['activeProfileId'] as String?;
  await profileStore.setActiveProfileId(activeProfileId);
}

/// [importSettingsBackup]のJSON文字列版。
Future<void> importSettingsBackupFromJson(
  String json, {
  required ConsentStore consentStore,
  required ProfileStore profileStore,
}) async {
  final data = jsonDecode(json) as Map<String, dynamic>;
  await importSettingsBackup(data, consentStore: consentStore, profileStore: profileStore);
}
