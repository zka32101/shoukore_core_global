import 'consent_audit_log.dart';

/// 同意履歴（`ConsentAuditLog`）に、最後のイベントから長期間何も記録
/// されていない空白期間があるかを検知する純関数。`ConsentAuditLog`自体は
/// 履歴の追記・整理のみを行い、記録が途絶えていないかは見ない。
/// `ConsentRenewalReminder`は同意の期限切れ前の事前通知のみを見るため、
/// 履歴自体の空白は見ない。実際の同意状態の再確認案内はアプリ側の
/// 責務とする。
class ConsentAuditLogGapDetector {
  const ConsentAuditLogGapDetector({this.gapPeriod = const Duration(days: 400)});

  /// 最後のイベントからこの期間を超えて記録がなければ空白とみなす。
  final Duration gapPeriod;

  /// [entries]（履歴、古い順）のうち最新のイベントから[now]までの経過が
  /// [gapPeriod]を超えていれば空白と判定する。履歴が空の場合は`false`を
  /// 返す（同意自体が未取得の状態は`ConsentExpiryPolicy`が扱うため）。
  bool hasGap(List<ConsentAuditEntry> entries, DateTime now) {
    if (entries.isEmpty) return false;
    final latest = entries.last.occurredAt;
    return now.difference(latest) > gapPeriod;
  }
}
