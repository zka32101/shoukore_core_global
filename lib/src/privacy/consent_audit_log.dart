/// 同意に関する1件のイベント（付与・撤回・ポリシー更新等）。
class ConsentAuditEntry {
  const ConsentAuditEntry({
    required this.type,
    required this.occurredAt,
    this.policyVersion,
  });

  /// イベント種別。本コアは文字列の意味を規定せず、アプリ側が決める
  /// 任意の値（例: 'granted'/'revoked'/'policy_updated'）を受け入れる。
  final String type;

  final DateTime occurredAt;

  /// イベント発生時点のプライバシーポリシーバージョン（任意）。
  final int? policyVersion;
}

/// 同意の付与・撤回・ポリシー更新などのイベント履歴を追記し、一定件数・
/// 期間で古い履歴を整理する純関数。保護者向けに「いつ何を同意したか」を
/// 遡れるようにする、`ConsentStore`（現在の同意状態のみを保持）とは別の
/// 履歴専用の仕組み。履歴自体の永続化はアプリ側の責務とする。
class ConsentAuditLog {
  const ConsentAuditLog({
    this.maxEntries = 50,
    this.maxAge = const Duration(days: 365 * 2),
  }) : assert(maxEntries > 0);

  /// 保持する履歴の最大件数（これを超えたら古いものから削除する）。
  final int maxEntries;

  /// この期間より古い履歴は削除する。
  final Duration maxAge;

  /// [entries]（既存の履歴、古い順）に[entry]を追記し、[maxAge]を超えた
  /// 履歴を削除した上で、[maxEntries]を超える分は古いものから削除した
  /// 新しい履歴を返す。
  List<ConsentAuditEntry> append(
    List<ConsentAuditEntry> entries,
    ConsentAuditEntry entry,
    DateTime now,
  ) {
    final updated = [...entries, entry]
      ..removeWhere((e) => now.difference(e.occurredAt) > maxAge);
    if (updated.length <= maxEntries) return updated;
    return updated.sublist(updated.length - maxEntries);
  }
}
