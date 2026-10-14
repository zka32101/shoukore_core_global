import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  final units = [
    const Unit(
      id: 'mat_probabilidade_1',
      subjectId: 'matematica',
      grade: 3,
      titleKey: 'unit_probabilidade_1',
      templateIds: ['tpl_max', 'tpl_min', 'tpl_mode'],
    ),
  ];

  final templates = {
    'tpl_max': const DataSetTemplate(
      id: 'tpl_max',
      operation: DataSetOperation.max,
      valueCount: 5,
      minValue: 1,
      maxValue: 20,
    ),
    'tpl_min': const DataSetTemplate(
      id: 'tpl_min',
      operation: DataSetOperation.min,
      valueCount: 5,
      minValue: 1,
      maxValue: 20,
    ),
    'tpl_mode': const DataSetTemplate(
      id: 'tpl_mode',
      operation: DataSetOperation.mode,
      valueCount: 5,
      minValue: 1,
      maxValue: 5,
    ),
  };

  late StatisticsQuestionSource source;

  setUp(() {
    source = StatisticsQuestionSource(unitsByLocale: {'pt_BR': units}, templates: templates);
  });

  Future<Question> generateFor(String templateId) async {
    final u = const Unit(
      id: 'tmp_unit',
      subjectId: 'matematica',
      grade: 3,
      titleKey: 'tmp',
      templateIds: [],
    );
    final single = StatisticsQuestionSource(
      unitsByLocale: {
        'pt_BR': [
          Unit(
            id: u.id,
            subjectId: u.subjectId,
            grade: u.grade,
            titleKey: u.titleKey,
            templateIds: [templateId],
          ),
        ],
      },
      templates: templates,
    );
    return single.generate(unitId: u.id, targetDifficulty: 0.5);
  }

  test('maxは与えられた値の最大値と一致する', () async {
    for (var i = 0; i < 20; i++) {
      final q = await generateFor('tpl_max');
      final values = q.params['values']!.split(',').map(int.parse).toList();
      final answer = int.parse(q.answer);
      expect(answer, values.reduce((a, b) => a > b ? a : b));
      expect(q.choices, contains(q.answer));
    }
  });

  test('minは与えられた値の最小値と一致する', () async {
    for (var i = 0; i < 20; i++) {
      final q = await generateFor('tpl_min');
      final values = q.params['values']!.split(',').map(int.parse).toList();
      final answer = int.parse(q.answer);
      expect(answer, values.reduce((a, b) => a < b ? a : b));
    }
  });

  test('modeは一意に決まる最頻値と一致する（過半数生成で保証）', () async {
    for (var i = 0; i < 20; i++) {
      final q = await generateFor('tpl_mode');
      final values = q.params['values']!.split(',').map(int.parse).toList();
      final answer = int.parse(q.answer);

      final counts = <int, int>{};
      for (final v in values) {
        counts[v] = (counts[v] ?? 0) + 1;
      }
      final maxCount = counts.values.reduce((a, b) => a > b ? a : b);
      final modes = counts.entries.where((e) => e.value == maxCount).map((e) => e.key).toSet();

      expect(modes, {answer}, reason: '最頻値が一意に決まっていること');
      expect(source.checkAnswer(q, q.answer), isTrue);
    }
  });
}
