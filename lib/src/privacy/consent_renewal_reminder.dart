import '../models/models.dart';

/// 保護者同意（[ConsentRecord]）の有効期限が近づいた際、期限切れになる前に
/// 再同意を促すリマインドを出すべきかを判定する純関数。`ConsentExpiryPolicy`
/// （既に期限切れ/再同意必須かどうかの判定）とは異なり、期限切れ前の
/// 事前リードタイムのみを扱う。実際のリマインド表示・送信処理はアプリ側の
/// 責務とする。
class ConsentRenewalReminder {
  const ConsentRenewalReminder({
    this.validity = const Duration(days: 365),
    this.leadTime = const Duration(days: 14),
  });

  /// 同意から期限切れまでの有効期間。`ConsentExpiryPolicy.validity`と
  /// 同じ値を渡して整合させる想定。
  final Duration validity;

  /// 期限切れの何日前からリマインドを出し始めるか。
  final Duration leadTime;

  /// [record]の同意が、期限切れ前だが[leadTime]以内に迫っている場合に
  /// `true`を返す。既に期限切れの場合や、同意が得られていない場合は
  /// `false`を返す（その場合は`ConsentExpiryPolicy`の再同意フローが扱う）。
  bool shouldRemind(ConsentRecord record, DateTime now) {
    if (!record.parentalConsentGiven || record.consentedAt == null) {
      return false;
    }
    final expiresAt = record.consentedAt!.add(validity);
    if (now.isAfter(expiresAt)) return false;
    return expiresAt.difference(now) <= leadTime;
  }
}
