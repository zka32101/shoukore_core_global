import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = UnitRecommendationIgnoredDetector(maxPresentationsBeforeIgnored: 5);

  test('提示回数が閾値未満なら無視と判定しない', () {
    expect(detector.isIgnored(3), isFalse);
  });

  test('提示回数が閾値以上なら無視と判定する', () {
    expect(detector.isIgnored(5), isTrue);
  });
}
