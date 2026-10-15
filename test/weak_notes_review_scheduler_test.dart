import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const profile = RegionalProfile(
    locale: 'ja',
    ageOfConsent: 16,
    guardianConsentRequired: false,
    dailyResetHour: 0,
    timeZone: 'Asia/Tokyo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );
  const boundary = DailyBoundary(profile);
  const scheduler = WeakNotesReviewScheduler();

  test('弱点がない場合はnextReviewDayがnull', () {
    const note = WeakNote(unitId: 'u1', misconceptionCounts: {});
    final state = scheduler.schedule(
      note: note,
      now: DateTime(2024, 1, 1),
      boundary: boundary,
    );
    expect(state.nextReviewDay, isNull);
  });

  test('誤解回数が多いほど復習間隔が短い', () {
    const heavy = WeakNote(unitId: 'u1', misconceptionCounts: {'a': 10});
    const light = WeakNote(unitId: 'u2', misconceptionCounts: {'a': 1});
    final now = DateTime(2024, 1, 1);

    final heavyState = scheduler.schedule(note: heavy, now: now, boundary: boundary);
    final lightState = scheduler.schedule(note: light, now: now, boundary: boundary);

    expect(heavyState.nextReviewDay, DateTime.utc(2024, 1, 2));
    expect(lightState.nextReviewDay, DateTime.utc(2024, 1, 8));
  });

  test('復習期限が来ているunitIdのみdueUnitIdsに含まれる', () {
    final states = [
      WeakNoteReviewState(unitId: 'due', nextReviewDay: DateTime.utc(2024, 1, 1)),
      WeakNoteReviewState(unitId: 'notYet', nextReviewDay: DateTime.utc(2024, 1, 10)),
      const WeakNoteReviewState(unitId: 'noSchedule'),
    ];

    final due = scheduler.dueUnitIds(
      states: states,
      now: DateTime(2024, 1, 5),
      boundary: boundary,
    );

    expect(due, ['due']);
  });
}
