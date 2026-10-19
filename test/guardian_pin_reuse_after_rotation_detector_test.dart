import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianPinReuseAfterRotationDetector', () {
    const detector = GuardianPinReuseAfterRotationDetector();

    test('新PINのハッシュが履歴に存在すれば再利用と判定', () {
      final result = detector.isReusedPin(
        newPinHash: 'hash_1234',
        previousPinHashes: ['hash_5678', 'hash_1234'],
      );
      expect(result, isTrue);
    });

    test('新PINのハッシュが履歴に存在しなければ再利用ではない', () {
      final result = detector.isReusedPin(
        newPinHash: 'hash_9999',
        previousPinHashes: ['hash_5678', 'hash_1234'],
      );
      expect(result, isFalse);
    });

    test('履歴が空なら再利用ではない', () {
      final result = detector.isReusedPin(
        newPinHash: 'hash_1234',
        previousPinHashes: const [],
      );
      expect(result, isFalse);
    });
  });
}
