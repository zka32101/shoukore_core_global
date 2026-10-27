import 'study_plan_task.dart';

/// `StudyPlanTask`の保存先を抽象化する。既定実装は端末内drift等。
/// Firestore等外部サービスに密結合しない。
abstract class StudyPlanTaskStore {
  Future<void> saveTask(StudyPlanTask task);

  Future<void> deleteTask(String taskId);

  Future<List<StudyPlanTask>> getAllTasks();
}
