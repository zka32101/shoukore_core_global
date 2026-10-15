import 'inventory_snapshot.dart';

/// 所持アイテム（`InventorySnapshot`）の永続化先を抽象化する。
/// `ProgressStore`/`GrowthStore`等と同様、既定実装は端末内drift(SQLite)。
abstract class InventoryStore {
  Future<InventorySnapshot> load();

  Future<void> save(InventorySnapshot snapshot);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて所持状態を消去する。
  Future<void> clearAll();
}
