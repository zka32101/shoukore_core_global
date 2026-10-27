import 'study_plan_task.dart';

/// 複数の`StudyPlanTask`から、未完了数・期限超過数・完了率を集計
/// する純関数。計画タスク一覧の進捗を一目で把握できるようにする
/// ための集計値を返す。実際の一覧UI表示自体はアプリ側の責務と
/// する。
class StudyPlanTaskListSummary {
  const StudyPlanTaskListSummary({
    required this.totalCount,
    required this.completedCount,
    required this.overdueCount,
  });

  /// タスクの総数。
  final int totalCount;

  /// 完了済みタスク数。
  final int completedCount;

  /// 未完了・期限超過のタスク数。
  final int overdueCount;

  /// 完了率（0.0〜1.0）。タスクが0件であれば0.0を返す。
  double get completionRatio {
    if (totalCount <= 0) {
      return 0.0;
    }
    return completedCount / totalCount;
  }

  /// [tasks]（学習計画タスク一覧）から、[asOf]時点の集計結果を算出する。
  factory StudyPlanTaskListSummary.from(
    Iterable<StudyPlanTask> tasks,
    DateTime asOf,
  ) {
    var completedCount = 0;
    var overdueCount = 0;
    var totalCount = 0;

    for (final task in tasks) {
      totalCount++;
      if (task.isCompleted) {
        completedCount++;
      } else if (task.isOverdue(asOf)) {
        overdueCount++;
      }
    }

    return StudyPlanTaskListSummary(
      totalCount: totalCount,
      completedCount: completedCount,
      overdueCount: overdueCount,
    );
  }
}
