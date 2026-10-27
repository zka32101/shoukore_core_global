import 'study_plan_task.dart';
import 'study_plan_task_store.dart';

/// `StudyPlanTaskStore`の端末内メモリ実装。テスト・プロトタイピング用途、
/// または永続化が不要な軽量アプリ向け。
class InMemoryStudyPlanTaskStore implements StudyPlanTaskStore {
  final Map<String, StudyPlanTask> _tasksById = {};

  @override
  Future<void> saveTask(StudyPlanTask task) async {
    _tasksById[task.id] = task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _tasksById.remove(taskId);
  }

  @override
  Future<List<StudyPlanTask>> getAllTasks() async {
    return _tasksById.values.toList();
  }
}
