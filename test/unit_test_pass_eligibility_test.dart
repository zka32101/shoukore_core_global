import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

Attempt _testAttempt(bool correct) => Attempt(
      questionId: 'q',
      unitId: 'u1',
      correct: correct,
      answeredAt: DateTime(2024, 1, 1),
      mode: 'test',
    );

void main() {
  const eligibility = UnitTestPassEligibility(
    requiredQuestions: 10,
    passAccuracy: 0.8,
  );

  test('件数が足りない(テストを完走していない)場合は不合格', () {
    final attempts = List.generate(5, (_) => _testAttempt(true));
    expect(eligibility.isPassed(attempts), isFalse);
  });

  test('正答率が閾値未満なら不合格', () {
    final attempts = [
      ...List.generate(7, (_) => _testAttempt(true)),
      ...List.generate(3, (_) => _testAttempt(false)),
    ];
    expect(eligibility.isPassed(attempts), isFalse);
  });

  test('正答率がちょうど閾値なら合格', () {
    final attempts = [
      ...List.generate(8, (_) => _testAttempt(true)),
      ...List.generate(2, (_) => _testAttempt(false)),
    ];
    expect(eligibility.isPassed(attempts), isTrue);
  });

  test('直近1回分(requiredQuestions件)のみを見る(受け直せば最新の結果になる)', () {
    final attempts = [
      // 直近(先頭)のテスト1回は全問不正解。
      ...List.generate(10, (_) => _testAttempt(false)),
      // それより前のテストは満点だったが、これは見ない。
      ...List.generate(10, (_) => _testAttempt(true)),
    ];
    expect(eligibility.isPassed(attempts), isFalse);
  });
}
