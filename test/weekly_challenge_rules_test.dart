import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const rules = WeeklyChallengeRules(totalTarget: 3);

  test('weekStartOfは月曜日を返す', () {
    // 2026-11-04は水曜日。同じ週の月曜は2026-11-02。
    expect(rules.weekStartOf(DateTime(2026, 11, 4)), DateTime(2026, 11, 2));
    // 月曜自体を渡した場合も同じ月曜を返す。
    expect(rules.weekStartOf(DateTime(2026, 11, 2)), DateTime(2026, 11, 2));
  });

  test('同じ週内なら件数が積み上がる', () {
    var state = WeeklyChallengeState.initial;
    state = rules.recordCorrectAnswer(previous: state, now: DateTime(2026, 11, 2));
    state = rules.recordCorrectAnswer(previous: state, now: DateTime(2026, 11, 3));
    expect(state.completedCount, 2);
    expect(state.weekStart, DateTime(2026, 11, 2));
  });

  test('目標に達したらそれ以上増えない', () {
    var state = WeeklyChallengeState.initial;
    for (var i = 0; i < 5; i++) {
      state = rules.recordCorrectAnswer(previous: state, now: DateTime(2026, 11, 2));
    }
    expect(state.completedCount, 3);
  });

  test('週をまたぐと0件から数え直す', () {
    final lastWeek = WeeklyChallengeState(weekStart: DateTime(2026, 11, 2), completedCount: 3);
    final next = rules.recordCorrectAnswer(previous: lastWeek, now: DateTime(2026, 11, 9));
    expect(next.weekStart, DateTime(2026, 11, 9));
    expect(next.completedCount, 1);
  });

  test('currentStateは保存せずに週またぎを反映する', () {
    final lastWeek = WeeklyChallengeState(weekStart: DateTime(2026, 11, 2), completedCount: 3);
    final current = rules.currentState(stored: lastWeek, now: DateTime(2026, 11, 9));
    expect(current.completedCount, 0);
    expect(current.weekStart, DateTime(2026, 11, 9));
  });
}
