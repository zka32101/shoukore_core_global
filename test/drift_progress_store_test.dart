import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

void main() {
  late ProgressDatabase db;
  late DriftProgressStore store;

  setUp(() {
    db = ProgressDatabase(NativeDatabase.memory());
    store = DriftProgressStore(db, masteryWindow: 3);
  });

  tearDown(() async {
    await db.close();
  });

  test('未学習の単元は score 0 を返す', () async {
    final mastery = await store.getMastery('mat_add_1');
    expect(mastery.score, 0);
    expect(mastery.lastPracticedAt, isNull);
  });

  test('直近の正答率で習熟度を算出する', () async {
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

  test('masteryWindow を超える件数は直近分のみ使う', () async {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    for (var i = 0; i < 2; i++) {
      await store.recordAttempt(Attempt(
        questionId: 'old_$i',
        unitId: 'mat_add_1',
        correct: false,
        answeredAt: clock.now(),
      ));
      clock.advance(const Duration(minutes: 1));
    }
    for (var i = 0; i < 3; i++) {
      await store.recordAttempt(Attempt(
        questionId: 'new_$i',
        unitId: 'mat_add_1',
        correct: true,
        answeredAt: clock.now(),
      ));
      clock.advance(const Duration(minutes: 1));
    }

    final mastery = await store.getMastery('mat_add_1');
    expect(mastery.score, 1.0);
  });

  test('clearAll で全記録が消える（保護者のデータ削除要求対応）', () async {
    await store.recordAttempt(Attempt(
      questionId: 'q1',
      unitId: 'mat_add_1',
      correct: true,
      answeredAt: DateTime.utc(2026, 10, 14),
    ));
    await store.clearAll();
    final mastery = await store.getMastery('mat_add_1');
    expect(mastery.score, 0);
  });
}
