import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('InMemoryNotificationScheduler', () {
    test('schedule/cancelで通知を管理できる', () async {
      final scheduler = InMemoryNotificationScheduler();
      await scheduler.schedule(
        id: 'daily_reminder',
        at: DateTime.utc(2026, 10, 15),
        titleKey: 'reminderTitle',
        bodyKey: 'reminderBody',
      );
      expect(scheduler.scheduled.containsKey('daily_reminder'), isTrue);

      await scheduler.cancel('daily_reminder');
      expect(scheduler.scheduled.containsKey('daily_reminder'), isFalse);
    });

    test('cancelAllで全件削除される', () async {
      final scheduler = InMemoryNotificationScheduler();
      await scheduler.schedule(
        id: 'a',
        at: DateTime.utc(2026, 10, 15),
        titleKey: 't',
        bodyKey: 'b',
      );
      await scheduler.schedule(
        id: 'b',
        at: DateTime.utc(2026, 10, 15),
        titleKey: 't',
        bodyKey: 'b',
      );
      await scheduler.cancelAll();
      expect(scheduler.scheduled, isEmpty);
    });
  });

  group('DailyReminderPlanner', () {
    const profile = RegionalProfile(
      locale: 'ja',
      ageOfConsent: 16,
      guardianConsentRequired: false,
      dailyResetHour: 5,
      timeZone: 'Asia/Tokyo',
      screenTimeLimitMinutes: 0,
      profilingAdsAllowed: false,
    );
    const planner = DailyReminderPlanner(profile);

    test('リセット時刻より前なら同日のリセット時刻を返す', () {
      final next = planner.nextResetAt(DateTime.utc(2026, 10, 14, 3));
      expect(next, DateTime.utc(2026, 10, 14, 5));
    });

    test('リセット時刻を過ぎていたら翌日のリセット時刻を返す', () {
      final next = planner.nextResetAt(DateTime.utc(2026, 10, 14, 6));
      expect(next, DateTime.utc(2026, 10, 15, 5));
    });

    test('reminderAtはリセット時刻のbefore分前', () {
      final reminder = planner.reminderAt(
        DateTime.utc(2026, 10, 14, 3),
        before: const Duration(hours: 1),
      );
      expect(reminder, DateTime.utc(2026, 10, 14, 4));
    });
  });
}
