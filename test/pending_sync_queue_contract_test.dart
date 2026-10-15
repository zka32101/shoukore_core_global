import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `PendingSyncQueue`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runPendingSyncQueueContractTests(
  String label,
  PendingSyncQueue Function() createQueue, {
  void Function()? disposeQueue,
}) {
  group(label, () {
    late PendingSyncQueue queue;

    setUp(() => queue = createQueue());

    if (disposeQueue != null) {
      tearDown(disposeQueue);
    }

    test('未追加の状態ではlistPendingは空', () async {
      expect(await queue.listPending(), isEmpty);
    });

    test('enqueueした内容をlistPendingで古い順に取得できる', () async {
      await queue.enqueue(PendingSyncItem(
        id: 'a',
        payload: {'type': 'attempt', 'correct': true},
        createdAt: DateTime.utc(2026, 10, 14, 10),
      ));
      await queue.enqueue(PendingSyncItem(
        id: 'b',
        payload: {'type': 'attempt', 'correct': false},
        createdAt: DateTime.utc(2026, 10, 14, 9),
      ));

      final pending = await queue.listPending();
      expect(pending.map((i) => i.id), ['b', 'a']);
      expect(pending.first.payload['type'], 'attempt');
    });

    test('markSyncedでキューから消える', () async {
      await queue.enqueue(PendingSyncItem(
        id: 'a',
        payload: {'type': 'attempt'},
        createdAt: DateTime.utc(2026, 10, 14),
      ));
      await queue.markSynced('a');

      expect(await queue.listPending(), isEmpty);
    });

    test('markFailedでretryCountが増える（キューには残る）', () async {
      await queue.enqueue(PendingSyncItem(
        id: 'a',
        payload: {'type': 'attempt'},
        createdAt: DateTime.utc(2026, 10, 14),
      ));
      await queue.markFailed('a');
      await queue.markFailed('a');

      final pending = await queue.listPending();
      expect(pending, hasLength(1));
      expect(pending.first.retryCount, 2);
    });

    test('clearAllで全件消える（保護者のデータ削除要求対応）', () async {
      await queue.enqueue(PendingSyncItem(
        id: 'a',
        payload: {'type': 'attempt'},
        createdAt: DateTime.utc(2026, 10, 14),
      ));
      await queue.clearAll();

      expect(await queue.listPending(), isEmpty);
    });
  });
}

void main() {
  runPendingSyncQueueContractTests(
    'InMemoryPendingSyncQueue',
    () => InMemoryPendingSyncQueue(),
  );

  ProgressDatabase? currentDb;
  runPendingSyncQueueContractTests(
    'DriftPendingSyncQueue',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftPendingSyncQueue(db);
    },
    disposeQueue: () => currentDb?.close(),
  );
}
