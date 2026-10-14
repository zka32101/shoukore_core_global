import 'package:drift/drift.dart';

import '../../models/models.dart';
import '../../progress/progress_store.dart';
import 'progress_database.dart';

/// `ProgressStore` の既定実装。端末内drift(SQLite)に保存する。
/// 習熟度は直近[masteryWindow]件の正答率で近似する（適応難易度は`adaptive`モジュール側の責務）。
class DriftProgressStore implements ProgressStore {
  DriftProgressStore(this._db, {this.masteryWindow = 20});

  final ProgressDatabase _db;
  final int masteryWindow;

  @override
  Future<void> recordAttempt(Attempt attempt) async {
    await _db.into(_db.attempts).insert(
          AttemptsCompanion.insert(
            questionId: attempt.questionId,
            unitId: attempt.unitId,
            correct: attempt.correct,
            chosenId: Value(attempt.chosenId),
            answeredAt: attempt.answeredAt,
            elapsedMs: Value(attempt.elapsedMs),
            mode: Value(attempt.mode),
          ),
        );
  }

  @override
  Future<List<Attempt>> getAttempts(String unitId, {int? limit}) async {
    final query = _db.select(_db.attempts)
      ..where((t) => t.unitId.equals(unitId))
      ..orderBy([(t) => OrderingTerm.desc(t.answeredAt)]);
    if (limit != null) {
      query.limit(limit);
    }
    final rows = await query.get();
    return rows.map(_toAttempt).toList();
  }

  @override
  Future<Mastery> getMastery(String unitId) async {
    final recent = await getAttempts(unitId, limit: masteryWindow);
    if (recent.isEmpty) {
      return Mastery(unitId: unitId, score: 0, lastPracticedAt: null);
    }
    final correctCount = recent.where((a) => a.correct).length;
    return Mastery(
      unitId: unitId,
      score: correctCount / recent.length,
      lastPracticedAt: recent.first.answeredAt,
    );
  }

  @override
  Future<List<Mastery>> getAllMastery() async {
    final unitIds = await (_db.selectOnly(_db.attempts, distinct: true)
          ..addColumns([_db.attempts.unitId]))
        .map((row) => row.read(_db.attempts.unitId)!)
        .get();
    return Future.wait(unitIds.map(getMastery));
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.attempts).go();
  }

  Attempt _toAttempt(AttemptRow row) => Attempt(
        questionId: row.questionId,
        unitId: row.unitId,
        correct: row.correct,
        answeredAt: row.answeredAt,
        chosenId: row.chosenId,
        elapsedMs: row.elapsedMs,
        mode: row.mode,
      );
}
