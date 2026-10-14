import 'package:drift/drift.dart';

import '../../growth/growth_snapshot.dart';
import '../../growth/growth_store.dart';
import 'progress_database.dart';

/// `GrowthStore`の既定実装。端末内drift(SQLite)に保存する。
/// 単一行(id=0)で最新のgrowth状態のみを保持する。
class DriftGrowthStore implements GrowthStore {
  DriftGrowthStore(this._db);

  static const _rowId = 0;

  final ProgressDatabase _db;

  @override
  Future<GrowthSnapshot> load() async {
    final row = await (_db.select(_db.growthStates)..where((t) => t.id.equals(_rowId)))
        .getSingleOrNull();
    if (row == null) return GrowthSnapshot.initial;
    return GrowthSnapshot(
      totalCorrectAnswers: row.totalCorrectAnswers,
      coinBalance: row.coinBalance,
      missionDay: row.missionDay,
      missionCompletedCount: row.missionCompletedCount,
      missionRewardClaimed: row.missionRewardClaimed,
    );
  }

  @override
  Future<void> save(GrowthSnapshot snapshot) async {
    await _db.into(_db.growthStates).insertOnConflictUpdate(
          GrowthStatesCompanion.insert(
            id: const Value(_rowId),
            totalCorrectAnswers: Value(snapshot.totalCorrectAnswers),
            coinBalance: Value(snapshot.coinBalance),
            missionDay: Value(snapshot.missionDay),
            missionCompletedCount: Value(snapshot.missionCompletedCount),
            missionRewardClaimed: Value(snapshot.missionRewardClaimed),
          ),
        );
  }

  @override
  Future<void> clearAll() async {
    await (_db.delete(_db.growthStates)..where((t) => t.id.equals(_rowId))).go();
  }
}
