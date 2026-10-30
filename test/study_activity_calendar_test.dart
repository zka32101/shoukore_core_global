import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

Attempt _attempt(DateTime answeredAt) => Attempt(
      questionId: 'q',
      unitId: 'u1',
      correct: true,
      answeredAt: answeredAt,
    );

void main() {
  test('同じ日の複数回答は1日として数える', () {
    final days = studiedDaysFromAttempts([
      _attempt(DateTime(2026, 10, 5, 9)),
      _attempt(DateTime(2026, 10, 5, 20, 30)),
    ]);
    expect(days, {DateTime(2026, 10, 5)});
  });

  test('異なる日の回答はそれぞれ別の日として集計される', () {
    final days = studiedDaysFromAttempts([
      _attempt(DateTime(2026, 10, 5)),
      _attempt(DateTime(2026, 10, 10)),
    ]);
    expect(days, {DateTime(2026, 10, 5), DateTime(2026, 10, 10)});
  });

  test('空の履歴なら空集合を返す', () {
    expect(studiedDaysFromAttempts(const []), isEmpty);
  });
}
