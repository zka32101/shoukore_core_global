import 'package:drift/drift.dart';

import '../../guardian/screen_time_snapshot.dart';
import '../../guardian/screen_time_store.dart';
import 'progress_database.dart';

/// `ScreenTimeStore`の既定実装。端末内drift(SQLite)に保存する。
/// 単一行(id=0)で「今日」の利用時間のみを保持する。
class DriftScreenTimeStore implements ScreenTimeStore {
  DriftScreenTimeStore(this._db);

  static const _rowId = 0;

  final ProgressDatabase _db;

  @override
  Future<ScreenTimeSnapshot> load() async {
    final row = await (_db.select(_db.screenTimeStates)..where((t) => t.id.equals(_rowId)))
        .getSingleOrNull();
    if (row == null) return ScreenTimeSnapshot.initial;
    return ScreenTimeSnapshot(usedTodayMinutes: row.usedTodayMinutes, day: row.day);
  }

  @override
  Future<void> save(ScreenTimeSnapshot snapshot) async {
    await _db.into(_db.screenTimeStates).insertOnConflictUpdate(
          ScreenTimeStatesCompanion.insert(
            id: const Value(_rowId),
            usedTodayMinutes: Value(snapshot.usedTodayMinutes),
            day: Value(snapshot.day),
          ),
        );
  }

  @override
  Future<void> clearAll() async {
    await (_db.delete(_db.screenTimeStates)..where((t) => t.id.equals(_rowId))).go();
  }
}
