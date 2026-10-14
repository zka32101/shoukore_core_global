import 'package:flutter_test/flutter_test.dart';

import '../tool/check_curriculum.dart';

void main() {
  Map<String, dynamic> baseDoc() => {
        'locale': 'pt_BR',
        'subjects': [
          {'id': 'matematica'},
        ],
        'templates': [
          {'id': 'tpl_add_1_10'},
        ],
        'units': <Map<String, dynamic>>[
          {
            'id': 'mat_numeros_1',
            'subjectId': 'matematica',
            'grade': 1,
            'titleKey': 'unit_numeros_1',
            'templateIds': ['tpl_add_1_10'],
          },
        ],
      };

  test('正しいカリキュラムJSONはエラーなし', () {
    final errors = validateCurriculumDoc('test.json', baseDoc());
    expect(errors, isEmpty);
  });

  test('unit idの重複を検出する', () {
    final doc = baseDoc();
    (doc['units'] as List).add(Map<String, dynamic>.from((doc['units'] as List).first as Map));
    final errors = validateCurriculumDoc('test.json', doc);
    expect(errors, contains(contains('重複')));
  });

  test('未定義のsubjectIdを検出する', () {
    final doc = baseDoc();
    (doc['units'] as List).cast<Map<String, dynamic>>().first['subjectId'] = 'unknown_subject';
    final errors = validateCurriculumDoc('test.json', doc);
    expect(errors, contains(contains('subjectId')));
  });

  test('未定義のtemplateIdを検出する', () {
    final doc = baseDoc();
    (doc['units'] as List).cast<Map<String, dynamic>>().first['templateIds'] = ['unknown_tpl'];
    final errors = validateCurriculumDoc('test.json', doc);
    expect(errors, contains(contains('templateId')));
  });

  test('存在しないparentIdを検出する', () {
    final doc = baseDoc();
    (doc['units'] as List).cast<Map<String, dynamic>>().first['parentId'] = 'unknown_unit';
    final errors = validateCurriculumDoc('test.json', doc);
    expect(errors, contains(contains('parentId')));
  });

  test('範囲外のgradeを検出する', () {
    final doc = baseDoc();
    (doc['units'] as List).cast<Map<String, dynamic>>().first['grade'] = 0;
    final errors = validateCurriculumDoc('test.json', doc);
    expect(errors, contains(contains('grade')));
  });

  test('有効なparentIdは許容する', () {
    final doc = baseDoc();
    (doc['units'] as List).add({
      'id': 'mat_numeros_1_child',
      'subjectId': 'matematica',
      'grade': 1,
      'titleKey': 'unit_numeros_1_child',
      'parentId': 'mat_numeros_1',
      'templateIds': <String>[],
    });
    final errors = validateCurriculumDoc('test.json', doc);
    expect(errors, isEmpty);
  });
}
