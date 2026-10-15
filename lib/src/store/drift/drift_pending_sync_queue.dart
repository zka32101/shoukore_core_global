import 'dart:convert';

import 'package:drift/drift.dart';

import '../../sync/pending_sync_item.dart';
import '../../sync/pending_sync_queue.dart';
import 'progress_database.dart';

/// `PendingSyncQueue`の既定実装。端末内drift(SQLite)に保存する。
/// `payload`はJSON文字列として保存するため、JSON互換の値のみ渡すこと。
class DriftPendingSyncQueue implements PendingSyncQueue {
  DriftPendingSyncQueue(this._db);

  final ProgressDatabase _db;

  @override
  Future<void> enqueue(PendingSyncItem item) async {
    await _db.into(_db.pendingSyncItems).insertOnConflictUpdate(
          PendingSyncItemsCompanion.insert(
            id: item.id,
            payloadJson: jsonEncode(item.payload),
            createdAt: item.createdAt,
            retryCount: Value(item.retryCount),
          ),
        );
  }

  @override
  Future<List<PendingSyncItem>> listPending() async {
    final rows = await (_db.select(_db.pendingSyncItems)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_toItem).toList();
  }

  @override
  Future<void> markSynced(String id) async {
    await (_db.delete(_db.pendingSyncItems)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> markFailed(String id) async {
    final row = await (_db.select(_db.pendingSyncItems)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await (_db.update(_db.pendingSyncItems)..where((t) => t.id.equals(id))).write(
      PendingSyncItemsCompanion(retryCount: Value(row.retryCount + 1)),
    );
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.pendingSyncItems).go();
  }

  PendingSyncItem _toItem(PendingSyncItemRow row) => PendingSyncItem(
        id: row.id,
        payload: jsonDecode(row.payloadJson) as Map<String, dynamic>,
        createdAt: row.createdAt,
        retryCount: row.retryCount,
      );
}
