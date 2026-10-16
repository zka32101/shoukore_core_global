import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const throttle = GuardianNotificationDigestThrottle(minimumInterval: Duration(hours: 1));

  test('直前送信がなければ抑制しない', () {
    expect(
      throttle.shouldThrottle(lastSentAt: null, now: DateTime(2024, 1, 1, 12)),
      isFalse,
    );
  });

  test('最小間隔未満なら抑制する', () {
    expect(
      throttle.shouldThrottle(
        lastSentAt: DateTime(2024, 1, 1, 12),
        now: DateTime(2024, 1, 1, 12, 30),
      ),
      isTrue,
    );
  });

  test('最小間隔以上空いていれば抑制しない', () {
    expect(
      throttle.shouldThrottle(
        lastSentAt: DateTime(2024, 1, 1, 12),
        now: DateTime(2024, 1, 1, 13),
      ),
      isFalse,
    );
  });
}
