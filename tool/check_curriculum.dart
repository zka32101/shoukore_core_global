// `curriculum/*.json` の整合性を検証する。本格的にカリキュラムを拡充していく前の
// 品質保証として、CIで単元ID重複・テンプレ参照・学年配当の明らかな誤りを検出する。
import 'dart:convert';
import 'dart:io';

/// [doc]（1ロケール分のカリキュラムJSON）を検証し、見つかったエラーメッセージ一覧を返す。
/// [filePath]はエラーメッセージに含めるラベルとしてのみ使う。
List<String> validateCurriculumDoc(String filePath, Map<String, dynamic> doc) {
  final errors = <String>[];

  final subjectIds = <String>{
    for (final s in (doc['subjects'] as List<dynamic>? ?? const []))
      (s as Map<String, dynamic>)['id'] as String,
  };

  final templateIds = <String>{
    for (final t in (doc['templates'] as List<dynamic>? ?? const []))
      (t as Map<String, dynamic>)['id'] as String,
  };

  final units =
      (doc['units'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();

  final unitIds = <String>{};
  for (final unit in units) {
    final id = unit['id'] as String;
    if (!unitIds.add(id)) {
      errors.add('$filePath: unit id が重複しています: $id');
    }
  }

  for (final unit in units) {
    final id = unit['id'] as String;

    final subjectId = unit['subjectId'] as String?;
    if (subjectId == null || !subjectIds.contains(subjectId)) {
      errors.add('$filePath: unit $id の subjectId "$subjectId" が subjects に未定義です');
    }

    final grade = unit['grade'] as int?;
    if (grade == null || grade < 1 || grade > 9) {
      errors.add('$filePath: unit $id の grade が不正です: $grade');
    }

    final parentId = unit['parentId'] as String?;
    if (parentId != null && !unitIds.contains(parentId)) {
      errors.add('$filePath: unit $id の parentId "$parentId" が存在しません');
    }

    final templateIdsOfUnit =
        (unit['templateIds'] as List<dynamic>? ?? const []).cast<String>();
    for (final templateId in templateIdsOfUnit) {
      if (!templateIds.contains(templateId)) {
        errors.add('$filePath: unit $id の templateId "$templateId" が templates に未定義です');
      }
    }
  }

  return errors;
}

void main() {
  final dir = Directory('curriculum');
  if (!dir.existsSync()) {
    stdout.writeln('curriculum/ not found, skipping.');
    return;
  }

  final errors = <String>[];
  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final doc = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final locale = doc['locale'] as String? ?? '(unknown)';
    final unitCount = (doc['units'] as List<dynamic>? ?? const []).length;

    errors.addAll(validateCurriculumDoc(file.path, doc));
    stdout.writeln('checked ${file.path} (locale=$locale, units=$unitCount)');
  }

  if (errors.isNotEmpty) {
    stderr.writeln('curriculum check failed:');
    for (final error in errors) {
      stderr.writeln('  $error');
    }
    exit(1);
  }

  stdout.writeln('curriculum check ok.');
}
