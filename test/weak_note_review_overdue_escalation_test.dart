import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeakNoteReviewOverdueEscalation', () {
    const escalation = WeakNoteReviewOverdueEscalation();
    const boundary = DailyBoundary(RegionalProfile(
      locale: 'ja',
      ageOfConsent: 13,
      guardianConsentRequired: true,
      dailyResetHour: 0,
      timeZone: 'UTC',
      screenTimeLimitMinutes: 0,
      profilingAdsAllowed: false,
    ));

    test('期限超過がoverdueThresholdを超えていれば長期放置と判定する', () {
      final state = WeakNoteReviewState(
        unitId: 'u1',
        nextReviewDay: DateTime.utc(2026, 1, 1),
      );
      final now = DateTime.utc(2026, 1, 10);
      expect(
        escalation.isOverdueEscalated(state: state, now: now, boundary: boundary),
        isTrue,
      );
    });

    test('期限超過がoverdueThreshold以内であれば長期放置と判定しない', () {
      final state = WeakNoteReviewState(
        unitId: 'u1',
        nextReviewDay: DateTime.utc(2026, 1, 1),
      );
      final now = DateTime.utc(2026, 1, 5);
      expect(
        escalation.isOverdueEscalated(state: state, now: now, boundary: boundary),
        isFalse,
      );
    });

    test('nextReviewDayがnullであれば長期放置と判定しない', () {
      final state = WeakNoteReviewState(unitId: 'u1', nextReviewDay: null);
      final now = DateTime.utc(2026, 1, 10);
      expect(
        escalation.isOverdueEscalated(state: state, now: now, boundary: boundary),
        isFalse,
      );
    });
  });
}
