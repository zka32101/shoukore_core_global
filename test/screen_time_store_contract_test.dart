import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `ScreenTimeStore`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runScreenTimeStoreContractTests(
  String label,
  ScreenTimeStore Function() createStore, {
  void Function()? disposeStore,
}) {
  group(label, () {
    late ScreenTimeStore store;

    setUp(() => store = createStore());

    if (disposeStore != null) {
      tearDown(disposeStore);
    }

    test('未保存状態ではinitialスナップショットを返す', () async {
      final snapshot = await store.load();
      expect(snapshot.usedTodayMinutes, 0);
      expect(snapshot.day, isNull);
    });

    test('saveした内容をloadで復元できる', () async {
      final day = DateTime.utc(2026, 10, 14);
      await store.save(ScreenTimeSnapshot(usedTodayMinutes: 15, day: day));

      final snapshot = await store.load();
      expect(snapshot.usedTodayMinutes, 15);
      expect(snapshot.day!.isAtSameMomentAs(day), isTrue);
    });

    test('saveを繰り返すと最新の内容で上書きされる', () async {
      final day = DateTime.utc(2026, 10, 14);
      await store.save(ScreenTimeSnapshot(usedTodayMinutes: 5, day: day));
      await store.save(ScreenTimeSnapshot(usedTodayMinutes: 10, day: day));

      final snapshot = await store.load();
      expect(snapshot.usedTodayMinutes, 10);
    });

    test('clearAllでinitialスナップショットに戻る（保護者のデータ削除要求対応）', () async {
      await store.save(ScreenTimeSnapshot(usedTodayMinutes: 20, day: DateTime.utc(2026, 10, 14)));
      await store.clearAll();

      final snapshot = await store.load();
      expect(snapshot.usedTodayMinutes, 0);
      expect(snapshot.day, isNull);
    });
  });
}

void main() {
  runScreenTimeStoreContractTests(
    'InMemoryScreenTimeStore',
    () => InMemoryScreenTimeStore(),
  );

  ProgressDatabase? currentDb;
  runScreenTimeStoreContractTests(
    'DriftScreenTimeStore',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftScreenTimeStore(db);
    },
    disposeStore: () => currentDb?.close(),
  );
}
