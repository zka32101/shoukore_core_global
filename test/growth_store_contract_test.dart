import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `GrowthStore`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runGrowthStoreContractTests(
  String label,
  GrowthStore Function() createStore, {
  void Function()? disposeStore,
}) {
  group(label, () {
    late GrowthStore store;

    setUp(() => store = createStore());

    if (disposeStore != null) {
      tearDown(disposeStore);
    }

    test('未保存状態ではinitialスナップショットを返す', () async {
      final snapshot = await store.load();
      expect(snapshot.totalCorrectAnswers, 0);
      expect(snapshot.coinBalance, 0);
      expect(snapshot.missionDay, isNull);
      expect(snapshot.missionCompletedCount, 0);
      expect(snapshot.missionRewardClaimed, isFalse);
      expect(snapshot.currentStreakDays, 0);
      expect(snapshot.lastStudiedDay, isNull);
    });

    test('saveした内容をloadで復元できる', () async {
      final missionDay = DateTime.utc(2026, 10, 14);
      await store.save(GrowthSnapshot(
        totalCorrectAnswers: 12,
        coinBalance: 30,
        missionDay: missionDay,
        missionCompletedCount: 3,
        missionRewardClaimed: true,
        currentStreakDays: 4,
        lastStudiedDay: missionDay,
      ));

      final snapshot = await store.load();
      expect(snapshot.totalCorrectAnswers, 12);
      expect(snapshot.coinBalance, 30);
      expect(snapshot.missionDay!.isAtSameMomentAs(missionDay), isTrue);
      expect(snapshot.missionCompletedCount, 3);
      expect(snapshot.missionRewardClaimed, isTrue);
      expect(snapshot.currentStreakDays, 4);
      expect(snapshot.lastStudiedDay!.isAtSameMomentAs(missionDay), isTrue);
    });

    test('saveを繰り返すと最新の内容で上書きされる', () async {
      await store.save(const GrowthSnapshot(totalCorrectAnswers: 1, coinBalance: 10));
      await store.save(const GrowthSnapshot(totalCorrectAnswers: 2, coinBalance: 20));

      final snapshot = await store.load();
      expect(snapshot.totalCorrectAnswers, 2);
      expect(snapshot.coinBalance, 20);
    });

    test('clearAllでinitialスナップショットに戻る（保護者のデータ削除要求対応）', () async {
      await store.save(const GrowthSnapshot(totalCorrectAnswers: 5, coinBalance: 50));
      await store.clearAll();

      final snapshot = await store.load();
      expect(snapshot.totalCorrectAnswers, 0);
      expect(snapshot.coinBalance, 0);
    });
  });
}

void main() {
  runGrowthStoreContractTests(
    'InMemoryGrowthStore',
    () => InMemoryGrowthStore(),
  );

  ProgressDatabase? currentDb;
  runGrowthStoreContractTests(
    'DriftGrowthStore',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftGrowthStore(db);
    },
    disposeStore: () => currentDb?.close(),
  );
}
