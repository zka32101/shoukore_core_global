import 'inventory_snapshot.dart';
import 'inventory_store.dart';

/// `InventoryStore`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftInventoryStore`（端末内drift）で、
/// 本実装は同じ契約を満たす（`test/inventory_store_contract_test.dart`参照）。
class InMemoryInventoryStore implements InventoryStore {
  InventorySnapshot _snapshot = InventorySnapshot.initial;

  @override
  Future<InventorySnapshot> load() async => _snapshot;

  @override
  Future<void> save(InventorySnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<void> clearAll() async {
    _snapshot = InventorySnapshot.initial;
  }
}
