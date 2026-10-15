import 'package:flutter_test/flutter_test.dart';

import '../tool/check_l10n_parity.dart';

void main() {
  test('すべてのファイルでキーが一致していればエラーなし', () {
    final keysByFile = {
      'a.arb': {'greeting', 'farewell'},
      'b.arb': {'greeting', 'farewell'},
    };
    expect(validateL10nParity(keysByFile), isEmpty);
  });

  test('基準ファイルに無いキーが余分にあれば検出する', () {
    final keysByFile = {
      'a.arb': {'greeting'},
      'b.arb': {'greeting', 'extra'},
    };
    final errors = validateL10nParity(keysByFile);
    expect(errors, ['b.arb: "a.arb"に無いキー "extra" が余分にあります']);
  });

  test('基準ファイルにあるキーが不足していれば検出する', () {
    final keysByFile = {
      'a.arb': {'greeting', 'farewell'},
      'b.arb': {'greeting'},
    };
    final errors = validateL10nParity(keysByFile);
    expect(errors, ['b.arb: "a.arb"にあるキー "farewell" が不足しています']);
  });

  test('ファイルが1つだけならエラーなし', () {
    final keysByFile = {'a.arb': {'greeting'}};
    expect(validateL10nParity(keysByFile), isEmpty);
  });

  test('messageKeysは@で始まるメタキーを除外する', () {
    final doc = {
      '@@locale': 'ja',
      'greeting': 'こんにちは',
      '@greeting': {'description': 'greeting text'},
    };
    expect(messageKeys(doc), {'greeting'});
  });
}
