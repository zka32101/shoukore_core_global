import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = GuardianPinWeaknessDetector();

  test('同一数字の繰り返しは弱いと判定する', () {
    expect(detector.isWeak('1111'), isTrue);
  });

  test('昇順の連番は弱いと判定する', () {
    expect(detector.isWeak('1234'), isTrue);
  });

  test('降順の連番は弱いと判定する', () {
    expect(detector.isWeak('4321'), isTrue);
  });

  test('ランダムなPINは弱いと判定しない', () {
    expect(detector.isWeak('3728'), isFalse);
  });
}
