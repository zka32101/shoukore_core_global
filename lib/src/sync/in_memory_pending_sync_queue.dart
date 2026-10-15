import 'pending_sync_item.dart';
import 'pending_sync_queue.dart';

/// `PendingSyncQueue`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftPendingSyncQueue`（端末内drift）で、
/// 本実装は同じ契約を満たす（`test/pending_sync_queue_contract_test.dart`参照）。
class InMemoryPendingSyncQueue implements PendingSyncQueue {
  final Map<String, PendingSyncItem> _items = {};

  @override
  Future<void> enqueue(PendingSyncItem item) async {
    _items[item.id] = item;
  }

  @override
  Future<List<PendingSyncItem>> listPending() async {
    final items = _items.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  @override
  Future<void> markSynced(String id) async {
    _items.remove(id);
  }

  @override
  Future<void> markFailed(String id) async {
    final item = _items[id];
    if (item == null) return;
    _items[id] = item.withRetryIncremented();
  }

  @override
  Future<void> clearAll() async {
    _items.clear();
  }
}
