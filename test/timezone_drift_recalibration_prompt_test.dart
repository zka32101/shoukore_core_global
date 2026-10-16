import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const prompt = TimeZoneDriftRecalibrationPrompt(consecutiveDriftsRequired: 2);

  test('連続観測回数が閾値未満なら促さない', () {
    expect(prompt.shouldPrompt(1), isFalse);
  });

  test('連続観測回数が閾値に達したら促す', () {
    expect(prompt.shouldPrompt(2), isTrue);
  });

  test('連続観測回数が0なら促さない', () {
    expect(prompt.shouldPrompt(0), isFalse);
  });
}
