import 'offline_sync_conflict_resolver.dart';

/// 複数端末から同じ内容のデータが重複して同期キューに積まれていないか
/// を判定する純関数。`OfflineSyncConflictResolver`（更新時刻が異なる
/// 競合の解決）とは異なり、本クラスは内容（payload）が完全に一致する
/// レコードが複数存在するかのみを見る。実際の重複除去・サーバー側への
/// 問い合わせはアプリ側の責務とする。
class DuplicateSyncPayloadDetector {
  const DuplicateSyncPayloadDetector();

  /// [records]のうち、[candidate]とpayloadが一致するものが既に含まれて
  /// いれば重複とみなす。
  bool isDuplicate({
    required SyncableRecord candidate,
    required Iterable<SyncableRecord> records,
  }) {
    return records.any((record) => _mapEquals(record.payload, candidate.payload));
  }

  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (!b.containsKey(entry.key) || b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
