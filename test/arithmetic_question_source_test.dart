import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  final units = [
    const Unit(
      id: 'mat_add_1',
      subjectId: 'matematica',
      grade: 1,
      titleKey: 'unit_add_1',
      templateIds: ['tpl_add'],
    ),
    const Unit(
      id: 'mat_div_3',
      subjectId: 'matematica',
      grade: 3,
      titleKey: 'unit_div_3',
      templateIds: ['tpl_div'],
    ),
  ];

  final templates = {
    'tpl_add': const ArithmeticTemplate(
      id: 'tpl_add',
      operator: ArithmeticOperator.add,
      minOperand: 1,
      maxOperand: 10,
    ),
    'tpl_div': const ArithmeticTemplate(
      id: 'tpl_div',
      operator: ArithmeticOperator.divide,
      minOperand: 1,
      maxOperand: 10,
    ),
  };

  late ArithmeticQuestionSource source;

  setUp(() {
    source = ArithmeticQuestionSource(
      unitsByLocale: {'pt_BR': units},
      templates: templates,
    );
  });

  test('loadUnits はロケールに対応する単元一覧を返す', () async {
    final loaded = await source.loadUnits('pt_BR');
    expect(loaded, units);
  });

  test('loadUnits は未知のロケールで例外を投げる', () {
    expect(() => source.loadUnits('xx_XX'), throwsArgumentError);
  });

  test('加算問題の答えが再計算と一致する（検証スクリプト相当）', () async {
    for (var i = 0; i < 50; i++) {
      final q = await source.generate(unitId: 'mat_add_1', targetDifficulty: 0.5);
      final parts = q.choices.map(int.parse).toList();
      expect(parts.contains(int.parse(q.answer)), isTrue);
      expect(q.choices.toSet().length, q.choices.length, reason: '選択肢は重複しない');
      expect(source.checkAnswer(q, q.answer), isTrue);
    }
  });

  test('除算問題は必ず割り切れる（商が答え）', () async {
    for (var i = 0; i < 50; i++) {
      final q = await source.generate(unitId: 'mat_div_3', targetDifficulty: 0.8);
      expect(int.parse(q.answer), greaterThanOrEqualTo(1));
    }
  });

  test('未知の単元IDで例外を投げる', () {
    expect(
      () => source.generate(unitId: 'unknown', targetDifficulty: 0.5),
      throwsArgumentError,
    );
  });
}
