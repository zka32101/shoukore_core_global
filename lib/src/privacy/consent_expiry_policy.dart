import '../models/models.dart';

/// 保護者同意（[ConsentRecord]）に有効期限を設け、一定期間ごとの再同意や、
/// 同意後にプライバシーポリシーが更新された場合の再同意が必要かどうかを
/// 判定する純関数。`ConsentStore`への保存・読込自体には関与しない。
class ConsentExpiryPolicy {
  const ConsentExpiryPolicy({
    this.validity = const Duration(days: 365),
    this.currentPolicyVersion = 1,
  });

  /// 同意から再同意が必要になるまでの期間。
  final Duration validity;

  /// 現在有効なプライバシーポリシーのバージョン。
  final int currentPolicyVersion;

  /// [record]の同意が期限切れ（[validity]を超過）かどうかを判定する。
  /// 同意が得られていない、または[ConsentRecord.consentedAt]が未設定の場合は
  /// 期限切れとして扱う。
  bool isExpired(ConsentRecord record, DateTime now) {
    if (!record.parentalConsentGiven || record.consentedAt == null) {
      return true;
    }
    return now.isAfter(record.consentedAt!.add(validity));
  }

  /// 有効期限切れ、または同意時のポリシーバージョンが[currentPolicyVersion]より
  /// 古い場合に再同意が必要と判定する。
  bool needsReconfirmation(ConsentRecord record, DateTime now) {
    if (isExpired(record, now)) {
      return true;
    }
    return record.policyVersion < currentPolicyVersion;
  }
}
