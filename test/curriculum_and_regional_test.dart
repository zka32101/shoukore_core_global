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

  test('pt_BR カリキュラムJSONは1º-5º ano×5eixo全25単元を持つ', () {
    final content = File('curriculum/pt_BR.json').readAsStringSync();
    final data = parseCurriculum(content);

    expect(data.units, hasLength(25));
    const eixoPrefixes = ['numeros', 'algebra', 'geometria', 'grandezas', 'probabilidade'];
    for (final prefix in eixoPrefixes) {
      for (var grade = 1; grade <= 5; grade++) {
        expect(
          data.units.any((u) => u.id == 'mat_${prefix}_$grade'),
          isTrue,
          reason: 'mat_${prefix}_$grade が存在すること',
        );
      }
    }
  });

  test('pt_BR カリキュラムJSONの単元はhabilidadeCodesとverifiedを持つ', () {
    final content = File('curriculum/pt_BR.json').readAsStringSync();
    final data = parseCurriculum(content);

    final numeros1 = data.units.firstWhere((u) => u.id == 'mat_numeros_1');
    expect(numeros1.habilidadeCodes, isNotEmpty);
    expect(numeros1.verified, isTrue);

    // verified:false の単元は現地教員レビュー前提であることを示す印なので、
    // 少なくとも1つは存在する（本格展開前に全数verifiedになってはいけない、という
    // 安全側のアサーションではなく、現状のデータに即した確認）。
    expect(data.units.any((u) => !u.verified), isTrue);
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

  test('en regional profile を読み込める（COPPA既定）', () {
    final content = File('regional/en.yaml').readAsStringSync();
    final profile = parseRegionalProfile(content);

    expect(profile.locale, 'en');
    expect(profile.ageOfConsent, 13);
    expect(profile.guardianConsentRequired, isTrue);
    expect(profile.profilingAdsAllowed, isFalse);
  });
}
