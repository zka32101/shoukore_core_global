import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('EntitlementGracePeriodEndingSoonReminder', () {
    const gracePeriod = EntitlementGracePeriod(graceDuration: Duration(days: 3));
    const reminder = EntitlementGracePeriodEndingSoonReminder(remainingTimeThreshold: Duration(hours: 24));
    final expiredAt = DateTime(2026, 10, 1);

    test('猶予期間中かつ残り時間が閾値以内ならtrue', () {
      final now = expiredAt.add(const Duration(days: 2, hours: 6));
      expect(
        reminder.isEndingSoon(expiredAt: expiredAt, now: now, gracePeriod: gracePeriod),
        isTrue,
      );
    });

    test('猶予期間中でも残り時間が閾値を超えていればfalse', () {
      final now = expiredAt.add(const Duration(hours: 1));
      expect(
        reminder.isEndingSoon(expiredAt: expiredAt, now: now, gracePeriod: gracePeriod),
        isFalse,
      );
    });

    test('猶予期間が既に終了していればfalse', () {
      final now = expiredAt.add(const Duration(days: 10));
      expect(
        reminder.isEndingSoon(expiredAt: expiredAt, now: now, gracePeriod: gracePeriod),
        isFalse,
      );
    });
  });
}
