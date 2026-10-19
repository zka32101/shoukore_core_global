import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('RegionalProfileLoadFailureFallbackNotice', () {
    const notice = RegionalProfileLoadFailureFallbackNotice(consecutiveFailureThreshold: 2);

    test('連続失敗回数が閾値以上なら通知が必要', () {
      expect(notice.shouldNotify(2), isTrue);
      expect(notice.shouldNotify(3), isTrue);
    });

    test('連続失敗回数が閾値未満なら通知は不要', () {
      expect(notice.shouldNotify(1), isFalse);
    });

    test('連続失敗回数が0なら通知は不要', () {
      expect(notice.shouldNotify(0), isFalse);
    });
  });
}
