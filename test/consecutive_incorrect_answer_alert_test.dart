import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

Attempt _attempt(bool correct) => Attempt(
      questionId: 'q',
      unitId: 'u1',
      correct: correct,
      answeredAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  const alert = ConsecutiveIncorrectAnswerAlert();

  test('連続不正解が閾値未満なら対象外', () {
    final attempts = [_attempt(false), _attempt(false), _attempt(true)];
    expect(alert.shouldAlert(attempts), isFalse);
  });

  test('先頭から連続して閾値回数不正解が続けばアラート対象', () {
    final attempts = [_attempt(false), _attempt(false), _attempt(false), _attempt(true)];
    expect(alert.shouldAlert(attempts), isTrue);
  });

  test('途中に正解を挟んだ連続不正解は数えない（先頭からの連続のみ）', () {
    final attempts = [_attempt(true), _attempt(false), _attempt(false), _attempt(false)];
    expect(alert.shouldAlert(attempts), isFalse);
  });

  test('履歴が空なら対象外', () {
    expect(alert.shouldAlert(const []), isFalse);
  });

  test('閾値はカスタマイズできる', () {
    const strict = ConsecutiveIncorrectAnswerAlert(alertThreshold: 1);
    expect(strict.shouldAlert([_attempt(false)]), isTrue);
  });
}
