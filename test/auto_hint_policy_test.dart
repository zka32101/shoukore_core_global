import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const policy = AutoHintPolicy();

  test('未学習(null)は自動ヒント表示対象', () {
    expect(policy.shouldShowHint(null), isTrue);
  });

  test('正答率が閾値未満なら自動ヒント表示対象', () {
    const mastery = Mastery(unitId: 'u1', score: 0.5);
    expect(policy.shouldShowHint(mastery), isTrue);
  });

  test('正答率が閾値以上なら自動ヒント表示対象ではない', () {
    const mastery = Mastery(unitId: 'u1', score: 0.8);
    expect(policy.shouldShowHint(mastery), isFalse);
  });

  test('閾値はカスタマイズできる', () {
    const strict = AutoHintPolicy(accuracyThreshold: 0.9);
    const mastery = Mastery(unitId: 'u1', score: 0.8);
    expect(strict.shouldShowHint(mastery), isTrue);
  });
}
