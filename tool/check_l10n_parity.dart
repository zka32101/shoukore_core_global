// `l10n/app_*.arb` 間のキー整合性を検証する。新しいロケールの翻訳が
// 一部キーの追加漏れ・不要な残留で他ロケールと食い違うことをCIで検出する。
// `@@locale`等のメタキー（先頭`@`）は対象外とし、実際の文言キーのみを比較する。
import 'dart:convert';
import 'dart:io';

/// arbファイルの内容から、文言キー（先頭`@`を除くメタキー以外）の集合を返す。
Set<String> messageKeys(Map<String, dynamic> doc) =>
    doc.keys.where((k) => !k.startsWith('@')).toSet();

/// 各ファイルのキー集合を比較し、基準（最初のファイル）とのキーの欠落・余剰を
/// エラーメッセージとして返す。
List<String> validateL10nParity(Map<String, Set<String>> keysByFile) {
  if (keysByFile.isEmpty) return const [];

  final baseFile = keysByFile.keys.first;
  final baseKeys = keysByFile[baseFile]!;

  final errors = <String>[];
  for (final entry in keysByFile.entries) {
    if (entry.key == baseFile) continue;
    final missing = baseKeys.difference(entry.value);
    final extra = entry.value.difference(baseKeys);
    for (final key in missing) {
      errors.add('${entry.key}: "$baseFile"にあるキー "$key" が不足しています');
    }
    for (final key in extra) {
      errors.add('${entry.key}: "$baseFile"に無いキー "$key" が余分にあります');
    }
  }
  return errors;
}

void main() {
  final dir = Directory('l10n');
  if (!dir.existsSync()) {
    stdout.writeln('l10n/ not found, skipping.');
    return;
  }

  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final keysByFile = <String, Set<String>>{};
  for (final file in files) {
    final doc = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final keys = messageKeys(doc);
    keysByFile[file.path] = keys;
    stdout.writeln('checked ${file.path} (keys=${keys.length})');
  }

  final errors = validateL10nParity(keysByFile);

  if (errors.isNotEmpty) {
    stderr.writeln('l10n parity check failed:');
    for (final error in errors) {
      stderr.writeln('  $error');
    }
    exit(1);
  }

  stdout.writeln('l10n parity check ok.');
}
