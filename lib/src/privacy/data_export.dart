import '../progress/progress_store.dart';
import 'consent_store.dart';

/// LGPD上の権利行使（データ書き出し要求）に対応する。保護者が自分の子の
/// 学習データ・同意状態をまとめて確認・保存できるよう、JSON化しやすい
/// `Map` として返す。実際のファイル保存・共有はアプリ側の責務。
Future<Map<String, dynamic>> exportUserData({
  required ConsentStore consentStore,
  required ProgressStore progressStore,
}) async {
  final consent = await consentStore.getConsent();
  final masteries = await progressStore.getAllMastery();

  return {
    'consent': consent == null
        ? null
        : {
            'parentalConsentGiven': consent.parentalConsentGiven,
            'consentedAt': consent.consentedAt?.toIso8601String(),
            'policyVersion': consent.policyVersion,
          },
    'progress': [
      for (final mastery in masteries)
        {
          'unitId': mastery.unitId,
          'score': mastery.score,
          'lastPracticedAt': mastery.lastPracticedAt?.toIso8601String(),
        },
    ],
  };
}
