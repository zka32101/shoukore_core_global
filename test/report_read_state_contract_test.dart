import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `ReportReadState`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runReportReadStateContractTests(
  String label,
  ReportReadState Function() createState, {
  void Function()? disposeState,
}) {
  group(label, () {
    late ReportReadState state;

    setUp(() => state = createState());

    if (disposeState != null) {
      tearDown(disposeState);
    }

    test('未記録のreportTypeはnullを返す', () async {
      expect(await state.getLastReadAt('weekly'), isNull);
    });

    test('markReadした内容をgetLastReadAtで取得できる', () async {
      final at = DateTime.utc(2026, 10, 14, 9);
      await state.markRead('weekly', at);

      final result = await state.getLastReadAt('weekly');
      expect(result!.isAtSameMomentAs(at), isTrue);
    });

    test('異なるreportTypeは互いに影響しない', () async {
      await state.markRead('weekly', DateTime.utc(2026, 10, 14));
      await state.markRead('daily', DateTime.utc(2026, 10, 13));

      expect((await state.getLastReadAt('weekly'))!.day, 14);
      expect((await state.getLastReadAt('daily'))!.day, 13);
    });

    test('同じreportTypeに再度markReadすると上書きされる', () async {
      await state.markRead('weekly', DateTime.utc(2026, 10, 10));
      await state.markRead('weekly', DateTime.utc(2026, 10, 14));

      expect((await state.getLastReadAt('weekly'))!.day, 14);
    });

    test('clearAllで全件消える（保護者のデータ削除要求対応）', () async {
      await state.markRead('weekly', DateTime.utc(2026, 10, 14));
      await state.clearAll();

      expect(await state.getLastReadAt('weekly'), isNull);
    });
  });
}

void main() {
  runReportReadStateContractTests(
    'InMemoryReportReadState',
    () => InMemoryReportReadState(),
  );

  ProgressDatabase? currentDb;
  runReportReadStateContractTests(
    'DriftReportReadState',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftReportReadState(db);
    },
    disposeState: () => currentDb?.close(),
  );
}
