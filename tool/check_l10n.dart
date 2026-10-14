// `Text('...')` の直書き文字列を検出し、CI を落とすための lint。
// shared_core の失敗パターン#2（文字列直書き約210箇所）の再発防止。
//
// ルール: `Text(` / `Text.rich(` の最初の引数が文字列リテラルであることを禁止する。
// 許可する書き方: `Text(l10n.someKey)` のように arb 経由の値を渡すこと。
import 'dart:io';

final _textLiteralCall = RegExp(r'Text(\.rich)?\s*\(\s*(['
    "'"
    r'"])');

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    return;
  }
  final violations = <String>[];
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    if (entity.path.endsWith('.g.dart')) continue;
    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (_textLiteralCall.hasMatch(line)) {
        violations.add('${entity.path}:${i + 1}: $line');
      }
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln('l10n lint failed: Text() への文字列直書きを検出しました。');
    stderr.writeln('文言は l10n/app_*.arb 経由の値を使ってください。');
    for (final v in violations) {
      stderr.writeln('  $v');
    }
    exit(1);
  }

  stdout.writeln('l10n lint ok: Text() 直書きなし。');
}
