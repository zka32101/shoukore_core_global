import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StudyPlanTaskListSummary', () {
    final now = DateTime(2026, 1, 10);

    test('完了数・期限超過数・完了率を正しく集計する', () {
      final tasks = [
        StudyPlanTask(id: '1', title: 'A', dueDate: DateTime(2026, 1, 5), isCompleted: true),
        StudyPlanTask(id: '2', title: 'B', dueDate: DateTime(2026, 1, 5)),
        StudyPlanTask(id: '3', title: 'C', dueDate: DateTime(2026, 1, 20)),
      ];

      final summary = StudyPlanTaskListSummary.from(tasks, now);

      expect(summary.totalCount, 3);
      expect(summary.completedCount, 1);
      expect(summary.overdueCount, 1);
      expect(summary.completionRatio, closeTo(1 / 3, 0.0001));
    });

    test('タスクが0件であれば完了率は0.0', () {
      final summary = StudyPlanTaskListSummary.from([], now);
      expect(summary.totalCount, 0);
      expect(summary.completionRatio, 0.0);
    });
  });
}
