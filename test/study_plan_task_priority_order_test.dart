import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StudyPlanTaskPriorityOrder', () {
    const order = StudyPlanTaskPriorityOrder();
    final now = DateTime(2026, 1, 10);

    test('期限超過・期限が早い・完了済みの順に並ぶ', () {
      final completed = StudyPlanTask(
        id: 'completed',
        title: '完了済み',
        dueDate: DateTime(2026, 1, 1),
        isCompleted: true,
      );
      final overdue = StudyPlanTask(
        id: 'overdue',
        title: '期限超過',
        dueDate: DateTime(2026, 1, 5),
      );
      final soon = StudyPlanTask(
        id: 'soon',
        title: '期限が近い',
        dueDate: DateTime(2026, 1, 20),
      );
      final later = StudyPlanTask(
        id: 'later',
        title: 'まだ先',
        dueDate: DateTime(2026, 2, 1),
      );

      final sorted = order.sort([later, completed, soon, overdue], now);

      expect(sorted.map((t) => t.id).toList(), [
        'overdue',
        'soon',
        'later',
        'completed',
      ]);
    });
  });
}
