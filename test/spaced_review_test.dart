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
  const scheduler = SpacedReviewScheduler();

  group('SpacedReviewScheduler', () {
    test('初回正解で箱レベル1、1日後に復習期限', () {
      final state = scheduler.recordResult(
        previous: null,
        questionId: 'q1',
        correct: true,
        now: DateTime.utc(2026, 10, 14),
        boundary: boundary,
      );
      expect(state.boxLevel, 1);
      expect(state.nextReviewDay, DateTime.utc(2026, 10, 14).add(const Duration(days: 2)));
    });

    test('誤答すると箱レベル0に戻る', () {
      const previous = ReviewState(questionId: 'q1', boxLevel: 3);
      final state = scheduler.recordResult(
        previous: previous,
        questionId: 'q1',
        correct: false,
        now: DateTime.utc(2026, 10, 14),
        boundary: boundary,
      );
      expect(state.boxLevel, 0);
      expect(state.nextReviewDay, DateTime.utc(2026, 10, 14).add(const Duration(days: 1)));
    });

    test('箱レベルは最大インデックスでクランプされる', () {
      const previous = ReviewState(questionId: 'q1', boxLevel: 4);
      final state = scheduler.recordResult(
        previous: previous,
        questionId: 'q1',
        correct: true,
        now: DateTime.utc(2026, 10, 14),
        boundary: boundary,
      );
      expect(state.boxLevel, 4);
    });

    test('dueQuestionIdsは期限が今日以前のものだけを返す', () {
      final states = [
        const ReviewState(questionId: 'due', boxLevel: 1, nextReviewDay: null),
        ReviewState(
          questionId: 'overdue',
          boxLevel: 1,
          nextReviewDay: DateTime.utc(2026, 10, 10),
        ),
        ReviewState(
          questionId: 'future',
          boxLevel: 1,
          nextReviewDay: DateTime.utc(2026, 10, 20),
        ),
      ];
      final due = scheduler.dueQuestionIds(
        states: states,
        now: DateTime.utc(2026, 10, 14),
        boundary: boundary,
      );
      expect(due, ['overdue']);
    });
  });
}
