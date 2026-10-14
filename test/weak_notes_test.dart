import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const analyzer = WeakNotesAnalyzer();

  final questions = {
    'q1': const Question(
      id: 'q1',
      unitId: 'mat_sub_2',
      type: QuestionType.choice,
      difficulty: 0.5,
      choices: ['3', '5', '13'],
      answer: '5',
      explanationId: 'exp1',
      misconceptionTags: {'3': 'sign_error', '13': 'borrow_error'},
    ),
    'q2': const Question(
      id: 'q2',
      unitId: 'mat_sub_2',
      type: QuestionType.choice,
      difficulty: 0.5,
      choices: ['3', '5', '13'],
      answer: '5',
      explanationId: 'exp1',
      misconceptionTags: {'3': 'sign_error', '13': 'borrow_error'},
    ),
    'q3': const Question(
      id: 'q3',
      unitId: 'mat_sub_2',
      type: QuestionType.choice,
      difficulty: 0.5,
      choices: ['3', '5', '13'],
      answer: '5',
      explanationId: 'exp1',
      misconceptionTags: {'3': 'sign_error', '13': 'borrow_error'},
    ),
  };

  Question lookup(String id) => questions[id]!;

  test('誤答の誤解タグを単元ごとに集計する', () {
    final attempts = [
      Attempt(
        questionId: 'q1',
        unitId: 'mat_sub_2',
        correct: false,
        chosenId: '3',
        answeredAt: DateTime.utc(2026, 10, 14),
      ),
      Attempt(
        questionId: 'q2',
        unitId: 'mat_sub_2',
        correct: false,
        chosenId: '3',
        answeredAt: DateTime.utc(2026, 10, 14),
      ),
      Attempt(
        questionId: 'q3',
        unitId: 'mat_sub_2',
        correct: true,
        chosenId: '5',
        answeredAt: DateTime.utc(2026, 10, 14),
      ),
    ];

    final note = analyzer.analyze(unitId: 'mat_sub_2', attempts: attempts, questionLookup: lookup);
    expect(note.misconceptionCounts, {'sign_error': 2});
    expect(note.hasWeakness, isTrue);
  });

  test('誤答がなければ弱点なし', () {
    final note = analyzer.analyze(unitId: 'mat_sub_2', attempts: const [], questionLookup: lookup);
    expect(note.hasWeakness, isFalse);
    expect(analyzer.topMisconception(note), isNull);
  });

  test('topMisconceptionは最頻出の誤解タイプを返す', () {
    final note = const WeakNote(unitId: 'u', misconceptionCounts: {'a': 1, 'b': 3, 'c': 2});
    expect(analyzer.topMisconception(note), 'b');
  });

  group('isOvercome', () {
    test('直近N件が連続正解かつそれ以前に同タグの誤答があれば克服と判定', () {
      final attemptsNewestFirst = [
        Attempt(questionId: 'q3', unitId: 'mat_sub_2', correct: true, chosenId: '5', answeredAt: DateTime.utc(2026, 10, 14, 3)),
        Attempt(questionId: 'q3', unitId: 'mat_sub_2', correct: true, chosenId: '5', answeredAt: DateTime.utc(2026, 10, 14, 2)),
        Attempt(questionId: 'q3', unitId: 'mat_sub_2', correct: true, chosenId: '5', answeredAt: DateTime.utc(2026, 10, 14, 1)),
        Attempt(questionId: 'q1', unitId: 'mat_sub_2', correct: false, chosenId: '3', answeredAt: DateTime.utc(2026, 10, 14, 0)),
      ];

      final overcome = analyzer.isOvercome(
        attemptsNewestFirst: attemptsNewestFirst,
        questionLookup: lookup,
        misconceptionTag: 'sign_error',
      );
      expect(overcome, isTrue);
    });

    test('直近に誤答が混ざっていれば克服していない', () {
      final attemptsNewestFirst = [
        Attempt(questionId: 'q1', unitId: 'mat_sub_2', correct: false, chosenId: '3', answeredAt: DateTime.utc(2026, 10, 14, 3)),
        Attempt(questionId: 'q3', unitId: 'mat_sub_2', correct: true, chosenId: '5', answeredAt: DateTime.utc(2026, 10, 14, 2)),
        Attempt(questionId: 'q3', unitId: 'mat_sub_2', correct: true, chosenId: '5', answeredAt: DateTime.utc(2026, 10, 14, 1)),
      ];

      final overcome = analyzer.isOvercome(
        attemptsNewestFirst: attemptsNewestFirst,
        questionLookup: lookup,
        misconceptionTag: 'sign_error',
        consecutiveCorrectRequired: 3,
      );
      expect(overcome, isFalse);
    });

    test('件数が足りない場合は克服していない', () {
      final attemptsNewestFirst = [
        Attempt(questionId: 'q3', unitId: 'mat_sub_2', correct: true, chosenId: '5', answeredAt: DateTime.utc(2026, 10, 14)),
      ];
      final overcome = analyzer.isOvercome(
        attemptsNewestFirst: attemptsNewestFirst,
        questionLookup: lookup,
        misconceptionTag: 'sign_error',
        consecutiveCorrectRequired: 3,
      );
      expect(overcome, isFalse);
    });
  });
}
