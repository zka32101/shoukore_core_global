import 'offline_sync_conflict_resolver.dart';

/// 同期コンフリクトの深刻度。
enum SyncConflictSeverity {
  /// 採用されなかった側の内容が実質同じ（データ破壊なし）。
  minor,

  /// 採用されなかった側に異なる内容が含まれており、データが失われる。
  major,
}

/// `OfflineSyncConflictResolver`が解決したコンフリクトについて、採用されな
/// かった側のデータが実質的に失われる重大なものか、同じ内容で実害のない
/// 軽微なものかを分類する純関数。`OfflineSyncConflictResolver`自体は
/// どちらを採用するか（last-write-wins）のみを判定するため、本クラスが
/// 採用されなかった側のpayloadを比較して深刻度を見る。実際のログ記録・
/// 保護者への報告はアプリ側の責務とする。
class SyncConflictSeverityClassifier {
  const SyncConflictSeverityClassifier();

  /// [local]と[remote]のうち[resolved]として採用されなかった側の
  /// payloadが、採用された側と異なる場合は[SyncConflictSeverity.major]、
  /// 同じ場合は[SyncConflictSeverity.minor]と判定する。
  SyncConflictSeverity classify({
    required SyncableRecord local,
    required SyncableRecord remote,
    required SyncableRecord resolved,
  }) {
    final discarded = identical(resolved, local) ? remote : local;
    final isSamePayload = _mapEquals(discarded.payload, resolved.payload);
    return isSamePayload ? SyncConflictSeverity.minor : SyncConflictSeverity.major;
  }

  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (!b.containsKey(entry.key) || b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
