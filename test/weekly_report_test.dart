import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  final questions = {
    'q1': const Question(
      id: 'q1',
      unitId: 'mat_sub_2',
      type: QuestionType.choice,
      difficulty: 0.5,
      choices: ['3', '5'],
      answer: '5',
      explanationId: 'exp1',
      misconceptionTags: {'3': 'sign_error'},
    ),
  };
  Question lookup(String id) => questions[id]!;

  test('直近期間内の記録のみ集計し、期間外は無視する', () async {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final store = _FakeProgressStore({
      'mat_sub_2': [
        Attempt(
          questionId: 'q1',
          unitId: 'mat_sub_2',
          correct: true,
          chosenId: '5',
          answeredAt: DateTime.utc(2026, 10, 13),
        ),
        Attempt(
          questionId: 'q1',
          unitId: 'mat_sub_2',
          correct: false,
          chosenId: '3',
          answeredAt: DateTime.utc(2026, 10, 12),
        ),
        Attempt(
          questionId: 'q1',
          unitId: 'mat_sub_2',
          correct: true,
          chosenId: '5',
          answeredAt: DateTime.utc(2026, 10, 1), // 期間外
        ),
      ],
    });

    const builder = WeeklyReportBuilder();
    final report = await builder.build(
      progressStore: store,
      unitIds: ['mat_sub_2'],
      clock: clock,
      questionLookup: lookup,
      periodDays: 7,
    );

    expect(report.totalAttempts, 2);
    expect(report.totalCorrect, 1);
    expect(report.overallAccuracy, closeTo(0.5, 1e-9));
    expect(report.units, hasLength(1));
    expect(report.units.first.unitId, 'mat_sub_2');
    expect(report.units.first.topMisconception, 'sign_error');
  });

  test('期間内に記録が無い単元はレポートに含まれない', () async {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final store = _FakeProgressStore({'mat_sub_2': []});

    const builder = WeeklyReportBuilder();
    final report = await builder.build(
      progressStore: store,
      unitIds: ['mat_sub_2'],
      clock: clock,
      questionLookup: lookup,
    );

    expect(report.units, isEmpty);
    expect(report.totalAttempts, 0);
    expect(report.overallAccuracy, 0);
  });
}

class _FakeProgressStore implements ProgressStore {
  _FakeProgressStore(this._attemptsByUnit);

  final Map<String, List<Attempt>> _attemptsByUnit;

  @override
  Future<void> recordAttempt(Attempt attempt) async {}

  @override
  Future<List<Attempt>> getAttempts(String unitId, {int? limit}) async =>
      _attemptsByUnit[unitId] ?? [];

  @override
  Future<Mastery> getMastery(String unitId) async =>
      Mastery(unitId: unitId, score: 0, lastPracticedAt: null);

  @override
  Future<List<Mastery>> getAllMastery() async => [];

  @override
  Future<void> clearAll() async {}
}
