import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const token = MissionStreakFreezeToken();

  test('トークンを1つ以上所持していれば消費すべきと判定する', () {
    expect(token.shouldConsumeToken(heldTokenCount: 1), isTrue);
  });

  test('トークンを複数所持していても消費すべきと判定する', () {
    expect(token.shouldConsumeToken(heldTokenCount: 5), isTrue);
  });

  test('トークンを所持していなければ消費しない', () {
    expect(token.shouldConsumeToken(heldTokenCount: 0), isFalse);
  });
}
