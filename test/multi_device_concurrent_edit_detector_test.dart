import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('MultiDeviceConcurrentEditDetector', () {
    const detector = MultiDeviceConcurrentEditDetector();

    test('異なるデバイスから時間差が小さければ同時編集と判定する', () {
      final first = DateTime(2026, 1, 1, 10, 0, 0);
      final second = DateTime(2026, 1, 1, 10, 2, 0);
      expect(
        detector.isLikelyConcurrentEdit(
          firstUpdatedAt: first,
          firstDeviceId: 'device-a',
          secondUpdatedAt: second,
          secondDeviceId: 'device-b',
        ),
        isTrue,
      );
    });

    test('同じデバイスからの更新は同時編集と判定しない', () {
      final first = DateTime(2026, 1, 1, 10, 0, 0);
      final second = DateTime(2026, 1, 1, 10, 1, 0);
      expect(
        detector.isLikelyConcurrentEdit(
          firstUpdatedAt: first,
          firstDeviceId: 'device-a',
          secondUpdatedAt: second,
          secondDeviceId: 'device-a',
        ),
        isFalse,
      );
    });

    test('時間差がconcurrencyWindowを超えていれば同時編集と判定しない', () {
      final first = DateTime(2026, 1, 1, 10, 0, 0);
      final second = DateTime(2026, 1, 1, 10, 10, 0);
      expect(
        detector.isLikelyConcurrentEdit(
          firstUpdatedAt: first,
          firstDeviceId: 'device-a',
          secondUpdatedAt: second,
          secondDeviceId: 'device-b',
        ),
        isFalse,
      );
    });
  });
}
