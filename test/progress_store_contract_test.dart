import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `ProgressStore`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runProgressStoreContractTests(
  String label,
  ProgressStore Function() createStore, {
  void Function()? disposeStore,
}) {
  group(label, () {
    late ProgressStore store;

    setUp(() => store = createStore());

    if (disposeStore != null) {
      tearDown(disposeStore);
    }

    test('未学習の単元は score 0、lastPracticedAt はnull', () async {
      final mastery = await store.getMastery('mat_add_1');
      expect(mastery.score, 0);
      expect(mastery.lastPracticedAt, isNull);
    });

    test('直近の正答率で習熟度を算出し、lastPracticedAtは最新の回答時刻', () async {
      final clock = FixedClock(DateTime.utc(2026, 10, 14));
      await store.recordAttempt(Attempt(
        questionId: 'q1',
        unitId: 'mat_add_1',
        correct: true,
        answeredAt: clock.now(),
      ));
      clock.advance(const Duration(minutes: 1));
      await store.recordAttempt(Attempt(
        questionId: 'q2',
        unitId: 'mat_add_1',
        correct: false,
        answeredAt: clock.now(),
      ));
      clock.advance(const Duration(minutes: 1));
      await store.recordAttempt(Attempt(
        questionId: 'q3',
        unitId: 'mat_add_1',
        correct: true,
        answeredAt: clock.now(),
      ));

      final mastery = await store.getMastery('mat_add_1');
      expect(mastery.score, closeTo(2 / 3, 1e-9));
      expect(mastery.lastPracticedAt!.isAtSameMomentAs(clock.now()), isTrue);
    });

    test('getAttemptsは新しい順に並び、limitで件数を絞れる', () async {
      final clock = FixedClock(DateTime.utc(2026, 10, 14));
      for (var i = 0; i < 3; i++) {
        await store.recordAttempt(Attempt(
          questionId: 'q$i',
          unitId: 'mat_add_1',
          correct: true,
          answeredAt: clock.now(),
        ));
        clock.advance(const Duration(minutes: 1));
      }

      final all = await store.getAttempts('mat_add_1');
      expect(all.map((a) => a.questionId).toList(), ['q2', 'q1', 'q0']);

      final limited = await store.getAttempts('mat_add_1', limit: 2);
      expect(limited.map((a) => a.questionId).toList(), ['q2', 'q1']);
    });

    test('getAttemptsは他単元の記録を含まない', () async {
      await store.recordAttempt(Attempt(
        questionId: 'q1',
        unitId: 'mat_add_1',
        correct: true,
        answeredAt: DateTime.utc(2026, 10, 14),
      ));
      await store.recordAttempt(Attempt(
        questionId: 'q2',
        unitId: 'mat_sub_1',
        correct: true,
        answeredAt: DateTime.utc(2026, 10, 14),
      ));

      final attempts = await store.getAttempts('mat_add_1');
      expect(attempts, hasLength(1));
      expect(attempts.single.unitId, 'mat_add_1');
    });

    test('getAllMasteryは記録のある単元すべての習熟度を返す', () async {
      await store.recordAttempt(Attempt(
        questionId: 'q1',
        unitId: 'mat_add_1',
        correct: true,
        answeredAt: DateTime.utc(2026, 10, 14),
      ));
      await store.recordAttempt(Attempt(
        questionId: 'q2',
        unitId: 'mat_sub_1',
        correct: false,
        answeredAt: DateTime.utc(2026, 10, 14),
      ));

      final all = await store.getAllMastery();
      expect(all.map((m) => m.unitId).toSet(), {'mat_add_1', 'mat_sub_1'});
    });

    test('clearAllで全記録が消える（保護者のデータ削除要求対応）', () async {
      await store.recordAttempt(Attempt(
        questionId: 'q1',
        unitId: 'mat_add_1',
        correct: true,
        answeredAt: DateTime.utc(2026, 10, 14),
      ));
      await store.clearAll();

      final mastery = await store.getMastery('mat_add_1');
      expect(mastery.score, 0);
      expect(await store.getAttempts('mat_add_1'), isEmpty);
      expect(await store.getAllMastery(), isEmpty);
    });
  });
}

void main() {
  runProgressStoreContractTests(
    'InMemoryProgressStore',
    () => InMemoryProgressStore(masteryWindow: 3),
  );

  ProgressDatabase? currentDb;
  runProgressStoreContractTests(
    'DriftProgressStore',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftProgressStore(db, masteryWindow: 3);
    },
    disposeStore: () => currentDb?.close(),
  );
}
