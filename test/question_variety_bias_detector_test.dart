import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = QuestionVarietyBiasDetector(maxConsecutiveSameTag: 3);

  test('同一タグが連続していなければ偏りなし', () {
    expect(detector.isBiased(['a', 'b', 'a', 'b']), isFalse);
  });

  test('同一タグが閾値未満の連続なら偏りなし', () {
    expect(detector.isBiased(['a', 'a', 'b']), isFalse);
  });

  test('同一タグが閾値以上連続していれば偏りと判定する', () {
    expect(detector.isBiased(['a', 'a', 'a', 'b']), isTrue);
  });

  test('履歴が閾値未満の件数なら偏りなし', () {
    expect(detector.isBiased(['a', 'a']), isFalse);
  });
}
