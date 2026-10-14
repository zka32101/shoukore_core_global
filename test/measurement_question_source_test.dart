import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  final units = [
    const Unit(
      id: 'mat_grandezas_1',
      subjectId: 'matematica',
      grade: 2,
      titleKey: 'unit_grandezas_1',
      templateIds: ['tpl_cm_to_m'],
    ),
  ];

  final templates = {
    'tpl_cm_to_m': const UnitConversionTemplate(
      id: 'tpl_cm_to_m',
      fromUnitKey: 'unit_cm',
      toUnitKey: 'unit_m',
      factor: 100,
      minValue: 1,
      maxValue: 10,
    ),
  };

  late MeasurementQuestionSource source;

  setUp(() {
    source = MeasurementQuestionSource(unitsByLocale: {'pt_BR': units}, templates: templates);
  });

  test('変換後の値が正しい倍率で問題文パラメータに反映される', () async {
    for (var i = 0; i < 30; i++) {
      final q = await source.generate(unitId: 'mat_grandezas_1', targetDifficulty: 0.5);
      final answer = int.parse(q.answer);
      final value = int.parse(q.params['value']!);
      expect(value, answer * 100);
      expect(q.choices, contains(q.answer));
      expect(source.checkAnswer(q, q.answer), isTrue);
    }
  });
}
