/// `WeeklyStudyPlanReviewPrompt`による週次振り返りの案内を、複数週に
/// わたって連続で無視している状態を検知する純関数。
/// `WeeklyStudyPlanReviewPrompt`自体は「今が振り返りタイミングか」の
/// 判定のみを行い、連続して無視されているかは見ないため、本クラスが
/// それを補う。実際の案内方法の見直し提案自体はアプリ側の責務とする。
class WeeklyStudyPlanReviewPromptDismissalStreakDetector {
  const WeeklyStudyPlanReviewPromptDismissalStreakDetector({
    this.streakThreshold = 2,
  }) : assert(streakThreshold > 0);

  /// 連続してこの週数以上無視されていれば放置状態とみなす。
  final int streakThreshold;

  /// [consecutiveDismissedWeekCount]（直近から連続して振り返りが
  /// 行われなかった週数）が[streakThreshold]以上であれば、放置状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissedWeekCount) {
    return consecutiveDismissedWeekCount >= streakThreshold;
  }
}
