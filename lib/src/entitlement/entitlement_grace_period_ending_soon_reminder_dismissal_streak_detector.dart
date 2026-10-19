/// `EntitlementGracePeriodEndingSoonReminder`による猶予期間終了間近の
/// 通知が連続して無視され続けている状態を検知する純関数。
/// `EntitlementGracePeriodEndingSoonReminder`自体は通知すべきかどうかの
/// 判定のみを行い、出した後にユーザーがどう反応したかは見ない。
/// `EntitlementGracePeriodRepeatedUsageDetector`は猶予期間が課金サイクル
/// ごとに繰り返し使われているパターンのみを見るため、終了間近通知への
/// 反応は見ない。実際の通知方法の見直し案内はアプリ側の責務とする。
class EntitlementGracePeriodEndingSoonReminderDismissalStreakDetector {
  const EntitlementGracePeriodEndingSoonReminderDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された猶予期間
  /// 終了間近通知の回数）が[dismissalThreshold]以上であれば、連続無視
  /// 状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
