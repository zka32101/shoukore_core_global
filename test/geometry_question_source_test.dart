import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  final units = [
    const Unit(
      id: 'mat_geometria_1',
      subjectId: 'matematica',
      grade: 1,
      titleKey: 'unit_geometria_1',
      templateIds: ['tpl_triangle', 'tpl_square'],
    ),
  ];

  final templates = {
    'tpl_triangle': const ShapeTemplate(id: 'tpl_triangle', shapeNameKey: 'shape_triangle', sides: 3),
    'tpl_square': const ShapeTemplate(id: 'tpl_square', shapeNameKey: 'shape_square', sides: 4),
  };

  late GeometryQuestionSource source;

  setUp(() {
    source = GeometryQuestionSource(unitsByLocale: {'pt_BR': units}, templates: templates);
  });

  test('図形の辺の数が答えとして選択肢に含まれる', () async {
    for (var i = 0; i < 30; i++) {
      final q = await source.generate(unitId: 'mat_geometria_1', targetDifficulty: 0.5);
      expect(q.choices, contains(q.answer));
      expect(q.choices.toSet().length, q.choices.length);
      expect(source.checkAnswer(q, q.answer), isTrue);
      expect(q.params['shapeNameKey'], anyOf('shape_triangle', 'shape_square'));
    }
  });
}
