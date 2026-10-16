import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = GuardianTimezoneMismatchDetector(threshold: Duration(hours: 1));

  test('オフセットが同じなら不一致ではない', () {
    expect(
      detector.hasMismatch(
        childUtcOffset: const Duration(hours: 9),
        parentUtcOffset: const Duration(hours: 9),
      ),
      isFalse,
    );
  });

  test('オフセット差が閾値以内なら不一致ではない', () {
    expect(
      detector.hasMismatch(
        childUtcOffset: const Duration(hours: 9),
        parentUtcOffset: const Duration(hours: 9, minutes: 30),
      ),
      isFalse,
    );
  });

  test('オフセット差が閾値を超えれば不一致と判定する', () {
    expect(
      detector.hasMismatch(
        childUtcOffset: const Duration(hours: 9),
        parentUtcOffset: const Duration(hours: -3),
      ),
      isTrue,
    );
  });
}
