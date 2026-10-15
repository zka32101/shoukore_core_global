import '../../growth/inventory_snapshot.dart';
import '../../growth/inventory_store.dart';
import 'progress_database.dart';

/// `InventoryStore`の既定実装。端末内drift(SQLite)に保存する。
/// 所持アイテムごとに1行(`OwnedItems`)を保持する。
class DriftInventoryStore implements InventoryStore {
  DriftInventoryStore(this._db);

  final ProgressDatabase _db;

  @override
  Future<InventorySnapshot> load() async {
    final rows = await _db.select(_db.ownedItems).get();
    return InventorySnapshot(ownedItemIds: rows.map((r) => r.itemId).toSet());
  }

  @override
  Future<void> save(InventorySnapshot snapshot) async {
    await _db.transaction(() async {
      await _db.delete(_db.ownedItems).go();
      for (final itemId in snapshot.ownedItemIds) {
        await _db.into(_db.ownedItems).insert(OwnedItemsCompanion.insert(itemId: itemId));
      }
    });
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.ownedItems).go();
  }
}
