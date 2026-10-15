/// 同期対象データ1件の、競合解決に必要な最小情報。実際のペイロード形式
/// （学習記録かGrowthSnapshotか等）はアプリ側が決める任意のMapとし、
/// 本コアは`updatedAt`の比較のみを行う。
class SyncableRecord {
  const SyncableRecord({required this.payload, required this.updatedAt});

  final Map<String, dynamic> payload;
  final DateTime updatedAt;
}

/// オフライン中に複数端末で記録されたデータが同期時に競合した場合、
/// どちらを採用すべきかを判定する純関数。`PendingSyncQueue`がサーバーに
/// 送信した後、サーバー側の既存レコードとの突き合わせで使う想定で、
/// 実際のマージ処理・サーバーAPIの呼び出しはアプリ側の責務とする。
class OfflineSyncConflictResolver {
  const OfflineSyncConflictResolver();

  /// [local]と[remote]のうち、`updatedAt`が新しい方を採用する
  /// （last-write-wins）。同時刻の場合は[remote]を優先する
  /// （サーバー側を信頼できる原本とみなす）。
  SyncableRecord resolve({required SyncableRecord local, required SyncableRecord remote}) {
    return local.updatedAt.isAfter(remote.updatedAt) ? local : remote;
  }
}
