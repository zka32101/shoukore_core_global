import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeeklyStudyPlanReviewPrompt', () {
    const prompt = WeeklyStudyPlanReviewPrompt();

    test('既定では日曜日が振り返り対象', () {
      final sunday = DateTime(2026, 1, 11);
      expect(sunday.weekday, DateTime.sunday);
      expect(prompt.shouldPromptReview(sunday), isTrue);
    });

    test('振り返り曜日以外は対象外', () {
      final monday = DateTime(2026, 1, 12);
      expect(monday.weekday, DateTime.monday);
      expect(prompt.shouldPromptReview(monday), isFalse);
    });

    test('振り返り曜日を変更できる', () {
      const fridayPrompt = WeeklyStudyPlanReviewPrompt(
        reviewWeekday: DateTime.friday,
      );
      final friday = DateTime(2026, 1, 16);
      expect(friday.weekday, DateTime.friday);
      expect(fridayPrompt.shouldPromptReview(friday), isTrue);
    });
  });
}
