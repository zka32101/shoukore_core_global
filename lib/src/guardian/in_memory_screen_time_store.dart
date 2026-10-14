import 'screen_time_snapshot.dart';
import 'screen_time_store.dart';

/// `ScreenTimeStore`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftScreenTimeStore`（端末内drift）で、
/// 本実装は同じ契約を満たす（`test/screen_time_store_contract_test.dart`参照）。
class InMemoryScreenTimeStore implements ScreenTimeStore {
  ScreenTimeSnapshot _snapshot = ScreenTimeSnapshot.initial;

  @override
  Future<ScreenTimeSnapshot> load() async => _snapshot;

  @override
  Future<void> save(ScreenTimeSnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<void> clearAll() async {
    _snapshot = ScreenTimeSnapshot.initial;
  }
}
