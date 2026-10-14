import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  test('pt_BR カリキュラムJSONを読み込める', () {
    final content = File('curriculum/pt_BR.json').readAsStringSync();
    final data = parseCurriculum(content);

    expect(data.units, isNotEmpty);
    expect(data.templates, isNotEmpty);

    final numeros1 = data.units.firstWhere((u) => u.id == 'mat_numeros_1');
    expect(numeros1.grade, 1);
    expect(numeros1.templateIds, contains('tpl_add_1_10'));
    expect(data.templates['tpl_add_1_10']!.operator, ArithmeticOperator.add);
  });

  test('pt_BR カリキュラムJSONは他eixoのテンプレも読み込める', () {
    final content = File('curriculum/pt_BR.json').readAsStringSync();
    final data = parseCurriculum(content);

    expect(data.shapeTemplates['tpl_shape_triangle']!.sides, 3);
    expect(data.unitConversionTemplates['tpl_cm_to_m']!.factor, 100);
    expect(data.sequenceTemplates['tpl_sequence_1_10']!.length, 4);
    expect(data.dataSetTemplates['tpl_dataset_mode']!.operation, DataSetOperation.mode);

    final geometria1 = data.units.firstWhere((u) => u.id == 'mat_geometria_1');
    expect(geometria1.templateIds, contains('tpl_shape_triangle'));
  });

  test('ja カリキュラムJSONを読み込める', () {
    final content = File('curriculum/ja.json').readAsStringSync();
    final data = parseCurriculum(content);
    expect(data.units, isNotEmpty);
  });

  test('pt_BR regional profile を読み込める（LGPD/ECA Digital既定）', () {
    final content = File('regional/pt_BR.yaml').readAsStringSync();
    final profile = parseRegionalProfile(content);

    expect(profile.locale, 'pt_BR');
    expect(profile.ageOfConsent, 12);
    expect(profile.guardianConsentRequired, isTrue);
    expect(profile.profilingAdsAllowed, isFalse);
  });

  test('ja regional profile を読み込める', () {
    final content = File('regional/ja.yaml').readAsStringSync();
    final profile = parseRegionalProfile(content);
    expect(profile.locale, 'ja');
    expect(profile.dailyResetHour, 5);
  });
}
