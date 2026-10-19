import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('OfflineSessionResumeNotice', () {
    test('長時間オフラインから復帰し同期待ちが0件であれば案内すべきと判定する', () {
      const notice = OfflineSessionResumeNotice();

      final result = notice.shouldNotify(wasLongGap: true, pendingSyncCount: 0);

      expect(result, isTrue);
    });

    test('同期待ちが残っていれば案内しない', () {
      const notice = OfflineSessionResumeNotice();

      final result = notice.shouldNotify(wasLongGap: true, pendingSyncCount: 3);

      expect(result, isFalse);
    });

    test('長時間オフラインでなければ案内しない', () {
      const notice = OfflineSessionResumeNotice();

      final result = notice.shouldNotify(wasLongGap: false, pendingSyncCount: 0);

      expect(result, isFalse);
    });
  });
}
