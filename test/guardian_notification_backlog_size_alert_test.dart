import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianNotificationBacklogSizeAlert', () {
    const alert = GuardianNotificationBacklogSizeAlert(backlogThreshold: 5);

    test('抑制済み通知件数が閾値以上なら積み上がりと判定', () {
      expect(alert.isBacklogged(5), isTrue);
      expect(alert.isBacklogged(7), isTrue);
    });

    test('抑制済み通知件数が閾値未満なら積み上がりではない', () {
      expect(alert.isBacklogged(4), isFalse);
    });

    test('抑制済み通知件数が0なら積み上がりではない', () {
      expect(alert.isBacklogged(0), isFalse);
    });
  });
}
