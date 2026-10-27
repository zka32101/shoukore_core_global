import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StudyPlanTask', () {
    test('完了済みならisOverdueは常に偽', () {
      final task = StudyPlanTask(
        id: 't1',
        title: '算数の復習',
        dueDate: DateTime(2026, 1, 1),
        isCompleted: true,
      );
      expect(task.isOverdue(DateTime(2026, 2, 1)), isFalse);
    });

    test('未完了で期限を過ぎていればisOverdueは真', () {
      final task = StudyPlanTask(
        id: 't2',
        title: '国語の復習',
        dueDate: DateTime(2026, 1, 1),
      );
      expect(task.isOverdue(DateTime(2026, 2, 1)), isTrue);
    });

    test('未完了でまだ期限前ならisOverdueは偽', () {
      final task = StudyPlanTask(
        id: 't3',
        title: '理科の復習',
        dueDate: DateTime(2026, 3, 1),
      );
      expect(task.isOverdue(DateTime(2026, 2, 1)), isFalse);
    });

    test('copyWithでisCompletedのみ変更できる', () {
      final task = StudyPlanTask(
        id: 't4',
        title: '社会の復習',
        dueDate: DateTime(2026, 1, 1),
      );
      final completed = task.copyWith(isCompleted: true);
      expect(completed.isCompleted, isTrue);
      expect(completed.id, task.id);
      expect(completed.title, task.title);
      expect(completed.dueDate, task.dueDate);
    });
  });
}
