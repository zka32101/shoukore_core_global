import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SyncPayloadSizeAlert', () {
    const alert = SyncPayloadSizeAlert(maxBytes: 20);

    test('ペイロードサイズがmaxBytesを超えていれば肥大化と判定する', () {
      final item = PendingSyncItem(
        id: 'i1',
        payload: const {'data': 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'},
        createdAt: DateTime(2026, 1, 1),
      );
      expect(alert.isOversized(item), isTrue);
    });

    test('ペイロードサイズがmaxBytes以内であれば肥大化と判定しない', () {
      final item = PendingSyncItem(
        id: 'i1',
        payload: const {'a': 1},
        createdAt: DateTime(2026, 1, 1),
      );
      expect(alert.isOversized(item), isFalse);
    });

    test('estimateBytesはJSON化したバイト数を返す', () {
      final item = PendingSyncItem(
        id: 'i1',
        payload: const {'a': 1},
        createdAt: DateTime(2026, 1, 1),
      );
      expect(alert.estimateBytes(item), greaterThan(0));
    });
  });
}
