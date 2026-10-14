import 'growth_snapshot.dart';
import 'growth_store.dart';

/// `GrowthStore`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftGrowthStore`（端末内drift）で、
/// 本実装は同じ契約を満たす（`test/growth_store_contract_test.dart`参照）。
class InMemoryGrowthStore implements GrowthStore {
  GrowthSnapshot _snapshot = GrowthSnapshot.initial;

  @override
  Future<GrowthSnapshot> load() async => _snapshot;

  @override
  Future<void> save(GrowthSnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<void> clearAll() async {
    _snapshot = GrowthSnapshot.initial;
  }
}
