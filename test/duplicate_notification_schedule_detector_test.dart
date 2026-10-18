import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('DuplicateNotificationScheduleDetector', () {
    const detector = DuplicateNotificationScheduleDetector();
    final baseTime = DateTime(2026, 1, 1, 9, 0, 0);

    test('同一内容かつ短時間内の既存予約があれば重複と判定する', () {
      final existing = NotificationScheduleEntry(
        id: 'n1',
        at: baseTime,
        titleKey: 'mission_reminder_title',
        bodyKey: 'mission_reminder_body',
      );
      final candidate = NotificationScheduleEntry(
        id: 'n2',
        at: baseTime.add(const Duration(minutes: 5)),
        titleKey: 'mission_reminder_title',
        bodyKey: 'mission_reminder_body',
      );

      expect(
        detector.isDuplicate(candidate: candidate, scheduled: [existing]),
        isTrue,
      );
    });

    test('内容が異なれば重複と判定しない', () {
      final existing = NotificationScheduleEntry(
        id: 'n1',
        at: baseTime,
        titleKey: 'mission_reminder_title',
        bodyKey: 'mission_reminder_body',
      );
      final candidate = NotificationScheduleEntry(
        id: 'n2',
        at: baseTime.add(const Duration(minutes: 5)),
        titleKey: 'weekly_report_title',
        bodyKey: 'weekly_report_body',
      );

      expect(
        detector.isDuplicate(candidate: candidate, scheduled: [existing]),
        isFalse,
      );
    });

    test('duplicateWindowを超えていれば重複と判定しない', () {
      final existing = NotificationScheduleEntry(
        id: 'n1',
        at: baseTime,
        titleKey: 'mission_reminder_title',
        bodyKey: 'mission_reminder_body',
      );
      final candidate = NotificationScheduleEntry(
        id: 'n2',
        at: baseTime.add(const Duration(minutes: 20)),
        titleKey: 'mission_reminder_title',
        bodyKey: 'mission_reminder_body',
      );

      expect(
        detector.isDuplicate(candidate: candidate, scheduled: [existing]),
        isFalse,
      );
    });

    test('自分自身のidとは重複と判定しない', () {
      final candidate = NotificationScheduleEntry(
        id: 'n1',
        at: baseTime,
        titleKey: 'mission_reminder_title',
        bodyKey: 'mission_reminder_body',
      );

      expect(
        detector.isDuplicate(candidate: candidate, scheduled: [candidate]),
        isFalse,
      );
    });
  });
}
