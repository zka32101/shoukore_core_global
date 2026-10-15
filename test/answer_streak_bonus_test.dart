import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const bonus = AnswerStreakBonus(interval: 5, bonusPerInterval: 10);

  test('interval未満ならボーナスなし', () {
    expect(bonus.bonusFor(1), 0);
    expect(bonus.bonusFor(4), 0);
  });

  test('intervalちょうどならボーナスを返す', () {
    expect(bonus.bonusFor(5), 10);
  });

  test('intervalの倍数でなければボーナスなし', () {
    expect(bonus.bonusFor(6), 0);
    expect(bonus.bonusFor(9), 0);
  });

  test('intervalの倍数ならその都度ボーナスを返す', () {
    expect(bonus.bonusFor(10), 10);
    expect(bonus.bonusFor(15), 10);
  });

  test('0以下ならボーナスなし', () {
    expect(bonus.bonusFor(0), 0);
    expect(bonus.bonusFor(-1), 0);
  });
}
