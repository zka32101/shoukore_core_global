import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const suggester = DeviceLocaleSuggester(['ja', 'pt_BR', 'en']);

  test('完全一致（大文字小文字区別なし）', () {
    expect(suggester.suggest('ja'), 'ja');
    expect(suggester.suggest('PT_BR'), 'pt_BR');
  });

  test('ハイフン区切りもアンダースコアとして扱う', () {
    expect(suggester.suggest('pt-BR'), 'pt_BR');
  });

  test('完全一致がなければ言語コードで一致するものを返す', () {
    expect(suggester.suggest('pt_PT'), 'pt_BR');
    expect(suggester.suggest('ja_JP'), 'ja');
  });

  test('言語コードも一致しなければ先頭（既定ロケール）を返す', () {
    expect(suggester.suggest('fr_FR'), 'ja');
  });
}
