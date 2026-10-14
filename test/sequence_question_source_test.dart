import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  final units = [
    const Unit(
      id: 'mat_algebra_1',
      subjectId: 'matematica',
      grade: 1,
      titleKey: 'unit_algebra_1',
      templateIds: ['tpl_sequence'],
    ),
  ];

  final templates = {
    'tpl_sequence': const SequencePatternTemplate(
      id: 'tpl_sequence',
      startMin: 1,
      startMax: 5,
      stepMin: 1,
      stepMax: 3,
      length: 4,
    ),
  };

  late SequenceQuestionSource source;

  setUp(() {
    source = SequenceQuestionSource(unitsByLocale: {'pt_BR': units}, templates: templates);
  });

  test('等差数列の次の項が答えと一致する（検算）', () async {
    for (var i = 0; i < 30; i++) {
      final q = await source.generate(unitId: 'mat_algebra_1', targetDifficulty: 0.5);
      final terms = q.params['terms']!.split(',').map(int.parse).toList();
      expect(terms, hasLength(4));

      final step = terms[1] - terms[0];
      for (var j = 1; j < terms.length; j++) {
        expect(terms[j] - terms[j - 1], step);
      }

      final answer = int.parse(q.answer);
      expect(answer, terms.last + step);
      expect(q.choices, contains(q.answer));
      expect(source.checkAnswer(q, q.answer), isTrue);
    }
  });
}
