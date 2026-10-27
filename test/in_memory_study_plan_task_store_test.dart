import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('InMemoryStudyPlanTaskStore', () {
    test('保存したタスクを取得できる', () async {
      final store = InMemoryStudyPlanTaskStore();
      final task = StudyPlanTask(
        id: 't1',
        title: '算数の復習',
        dueDate: DateTime(2026, 1, 1),
      );

      await store.saveTask(task);
      final tasks = await store.getAllTasks();

      expect(tasks, hasLength(1));
      expect(tasks.first.id, 't1');
    });

    test('同じIDで保存すると上書きされる', () async {
      final store = InMemoryStudyPlanTaskStore();
      final task = StudyPlanTask(
        id: 't1',
        title: '算数の復習',
        dueDate: DateTime(2026, 1, 1),
      );
      await store.saveTask(task);
      await store.saveTask(task.copyWith(isCompleted: true));

      final tasks = await store.getAllTasks();
      expect(tasks, hasLength(1));
      expect(tasks.first.isCompleted, isTrue);
    });

    test('削除したタスクは取得されない', () async {
      final store = InMemoryStudyPlanTaskStore();
      final task = StudyPlanTask(
        id: 't1',
        title: '算数の復習',
        dueDate: DateTime(2026, 1, 1),
      );
      await store.saveTask(task);
      await store.deleteTask('t1');

      final tasks = await store.getAllTasks();
      expect(tasks, isEmpty);
    });
  });
}
