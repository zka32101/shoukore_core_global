import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `InventoryStore`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runInventoryStoreContractTests(
  String label,
  InventoryStore Function() createStore, {
  void Function()? disposeStore,
}) {
  group(label, () {
    late InventoryStore store;

    setUp(() => store = createStore());

    if (disposeStore != null) {
      tearDown(disposeStore);
    }

    test('未保存状態ではinitialスナップショットを返す', () async {
      final snapshot = await store.load();
      expect(snapshot.ownedItemIds, isEmpty);
    });

    test('saveした内容をloadで復元できる', () async {
      await store.save(const InventorySnapshot(ownedItemIds: {'avatar_cat', 'avatar_dog'}));

      final snapshot = await store.load();
      expect(snapshot.ownedItemIds, {'avatar_cat', 'avatar_dog'});
    });

    test('saveを繰り返すと最新の内容で上書きされる', () async {
      await store.save(const InventorySnapshot(ownedItemIds: {'avatar_cat'}));
      await store.save(const InventorySnapshot(ownedItemIds: {'avatar_cat', 'avatar_dog'}));

      final snapshot = await store.load();
      expect(snapshot.ownedItemIds, {'avatar_cat', 'avatar_dog'});
    });

    test('clearAllでinitialスナップショットに戻る（保護者のデータ削除要求対応）', () async {
      await store.save(const InventorySnapshot(ownedItemIds: {'avatar_cat'}));
      await store.clearAll();

      final snapshot = await store.load();
      expect(snapshot.ownedItemIds, isEmpty);
    });
  });
}

void main() {
  runInventoryStoreContractTests(
    'InMemoryInventoryStore',
    () => InMemoryInventoryStore(),
  );

  ProgressDatabase? currentDb;
  runInventoryStoreContractTests(
    'DriftInventoryStore',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftInventoryStore(db);
    },
    disposeStore: () => currentDb?.close(),
  );
}
