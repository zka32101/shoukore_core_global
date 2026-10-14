import 'dart:convert';

import '../models/models.dart';
import 'arithmetic_template.dart';

/// `curriculum/{locale}.json` の内容から単元ツリーとテンプレ定義を組み立てる。
class CurriculumData {
  const CurriculumData({required this.units, required this.templates});

  final List<Unit> units;
  final Map<String, ArithmeticTemplate> templates;
}

CurriculumData parseCurriculum(String jsonContent) {
  final doc = jsonDecode(jsonContent) as Map<String, dynamic>;

  final templates = <String, ArithmeticTemplate>{};
  for (final raw in (doc['templates'] as List<dynamic>? ?? const [])) {
    final tpl = ArithmeticTemplate.fromJson(raw as Map<String, dynamic>);
    templates[tpl.id] = tpl;
  }

  final units = (doc['units'] as List<dynamic>? ?? const [])
      .map((raw) => Unit.fromJson(raw as Map<String, dynamic>))
      .toList();

  return CurriculumData(units: units, templates: templates);
}
