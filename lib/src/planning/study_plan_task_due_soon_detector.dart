import 'study_plan_task.dart';

/// `StudyPlanTask`のうち、期限が近づいている（まだ過ぎていないが
/// 残り日数が少ない）未完了タスクを検出する純関数。期限超過自体は
/// `StudyPlanTask.isOverdue`が判定するため、本クラスは超過前の
/// 「もうすぐ期限」のみを対象とする。実際の通知・UI表示自体は
/// アプリ側の責務とする。
class StudyPlanTaskDueSoonDetector {
  const StudyPlanTaskDueSoonDetector({this.warningWindowInDays = 1})
      : assert(warningWindowInDays >= 0);

  /// 期限まで残りこの日数以内であれば「もうすぐ期限」とみなす。
  final int warningWindowInDays;

  /// [task]が未完了・未超過で、[asOf]から見て期限まで
  /// [warningWindowInDays]日以内であれば真を返す。
  bool isDueSoon(StudyPlanTask task, DateTime asOf) {
    if (task.isCompleted || task.isOverdue(asOf)) {
      return false;
    }
    final remaining = task.dueDate.difference(asOf);
    return remaining <= Duration(days: warningWindowInDays);
  }
}
