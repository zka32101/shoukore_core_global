/// 今週の学習計画タスクを振り返るべきタイミングかどうかを判定する
/// 純関数。週の最後の曜日（既定は日曜日）であれば振り返りを促す
/// 対象とする。実際の振り返りUI・通知自体はアプリ側の責務とする。
class WeeklyStudyPlanReviewPrompt {
  const WeeklyStudyPlanReviewPrompt({this.reviewWeekday = DateTime.sunday});

  /// 振り返りを促す曜日（`DateTime.monday`〜`DateTime.sunday`）。
  final int reviewWeekday;

  /// [now]の曜日が[reviewWeekday]であれば振り返り対象と判定する。
  bool shouldPromptReview(DateTime now) {
    return now.weekday == reviewWeekday;
  }
}
