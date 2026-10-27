import 'study_plan_task.dart';

/// 複数の`StudyPlanTask`を「期限超過→期限が近い→通常」の優先順に
/// 並べ替える純関数。期限超過のタスクを最優先、次に期限日が早い
/// タスクを優先することで、取り組むべき順序を提示する。実際の
/// 一覧UI表示自体はアプリ側の責務とする。
class StudyPlanTaskPriorityOrder {
  const StudyPlanTaskPriorityOrder();

  /// [tasks]を[asOf]時点の優先順（期限超過 → 期限が早い順）に並べ替
  /// えた新しいリストを返す。完了済みタスクは最後に回す。
  List<StudyPlanTask> sort(Iterable<StudyPlanTask> tasks, DateTime asOf) {
    final sorted = tasks.toList();
    sorted.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      final aOverdue = a.isOverdue(asOf);
      final bOverdue = b.isOverdue(asOf);
      if (aOverdue != bOverdue) {
        return aOverdue ? -1 : 1;
      }
      return a.dueDate.compareTo(b.dueDate);
    });
    return sorted;
  }
}
