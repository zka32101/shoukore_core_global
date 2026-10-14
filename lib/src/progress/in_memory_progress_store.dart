import '../models/models.dart';
import 'progress_store.dart';

/// `ProgressStore`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftProgressStore`（端末内drift）で、
/// 本実装は`masteryWindow`の意味も含めて同じ契約を満たす（`test/progress_store_contract_test.dart`参照）。
class InMemoryProgressStore implements ProgressStore {
  InMemoryProgressStore({this.masteryWindow = 20});

  final int masteryWindow;
  final List<Attempt> _attempts = [];

  @override
  Future<void> recordAttempt(Attempt attempt) async {
    _attempts.add(attempt);
  }

  @override
  Future<List<Attempt>> getAttempts(String unitId, {int? limit}) async {
    final filtered = _attempts.where((a) => a.unitId == unitId).toList()
      ..sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    if (limit != null && filtered.length > limit) {
      return filtered.sublist(0, limit);
    }
    return filtered;
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
    final unitIds = _attempts.map((a) => a.unitId).toSet();
    return Future.wait(unitIds.map(getMastery));
  }

  @override
  Future<void> clearAll() async {
    _attempts.clear();
  }
}
