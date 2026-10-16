import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const relapse = WeakNoteMisconceptionRelapse();
  final overcomeAt = DateTime(2024, 1, 10);

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
  };
  Question lookup(String id) => questions[id]!;

  test('克服後に誤答がなければ再発と判定しない', () {
    final attempts = [
      Attempt(
        questionId: 'q1',
        unitId: 'mat_sub_2',
        correct: true,
        answeredAt: overcomeAt.add(const Duration(days: 1)),
      ),
    ];
    expect(
      relapse.hasRelapsed(
        attemptsOldestFirst: attempts,
        questionLookup: lookup,
        misconceptionTag: 'sign_error',
        overcomeAt: overcomeAt,
      ),
      isFalse,
    );
  });

  test('克服後に同じ誤解タイプで誤答があれば再発と判定する', () {
    final attempts = [
      Attempt(
        questionId: 'q1',
        unitId: 'mat_sub_2',
        correct: false,
        chosenId: '3',
        answeredAt: overcomeAt.add(const Duration(days: 1)),
      ),
    ];
    expect(
      relapse.hasRelapsed(
        attemptsOldestFirst: attempts,
        questionLookup: lookup,
        misconceptionTag: 'sign_error',
        overcomeAt: overcomeAt,
      ),
      isTrue,
    );
  });

  test('克服時刻より前の誤答は再発と判定しない', () {
    final attempts = [
      Attempt(
        questionId: 'q1',
        unitId: 'mat_sub_2',
        correct: false,
        chosenId: '3',
        answeredAt: overcomeAt.subtract(const Duration(days: 1)),
      ),
    ];
    expect(
      relapse.hasRelapsed(
        attemptsOldestFirst: attempts,
        questionLookup: lookup,
        misconceptionTag: 'sign_error',
        overcomeAt: overcomeAt,
      ),
      isFalse,
    );
  });
}
