import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const calculator = CharacterGrowthCalculator();

  group('order=0（1体目）', () {
    test('正解数0は未所持(Lv0)', () {
      expect(calculator.levelForOrder(0, 0), 0);
    });

    test('1〜5問正解でLv1', () {
      expect(calculator.levelForOrder(0, 1), 1);
      expect(calculator.levelForOrder(0, 5), 1);
    });

    test('6〜10問正解でLv2', () {
      expect(calculator.levelForOrder(0, 6), 2);
      expect(calculator.levelForOrder(0, 10), 2);
    });

    test('25問正解でLv5(上限)', () {
      expect(calculator.levelForOrder(0, 25), 5);
    });

    test('25問を超えてもLv5で頭打ち', () {
      expect(calculator.levelForOrder(0, 100), 5);
    });
  });

  group('order=1（2体目、順送り）', () {
    test('1体目がLv5になる25問まではLv0(未所持)', () {
      expect(calculator.levelForOrder(1, 25), 0);
    });

    test('26問目から2体目がLv1になる', () {
      expect(calculator.levelForOrder(1, 26), 1);
    });

    test('50問正解で2体目もLv5', () {
      expect(calculator.levelForOrder(1, 50), 5);
    });
  });

  test('answersPerLevel/maxLevelはカスタマイズできる', () {
    const custom = CharacterGrowthCalculator(answersPerLevel: 2, maxLevel: 3);
    expect(custom.levelForOrder(0, 1), 1);
    expect(custom.levelForOrder(0, 2), 1);
    expect(custom.levelForOrder(0, 3), 2);
    expect(custom.levelForOrder(0, 6), 3);
    expect(custom.levelForOrder(1, 6), 0);
    expect(custom.levelForOrder(1, 7), 1);
  });
}
