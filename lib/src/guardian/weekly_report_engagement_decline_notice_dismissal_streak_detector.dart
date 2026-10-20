/// `WeeklyReportEngagementDeclineNotice`による週次レポートの通知方法見直し
/// 提案が連続して無視され続けている状態を検知する純関数。
/// `WeeklyReportEngagementDeclineNotice`自体は複数回のレポートにわたる
/// 既読傾向のみを見る単発判定であり、出した後にユーザーがどう反応したかは
/// 見ない。実際の表示方法の見直し案内はアプリ側の責務とする。
class WeeklyReportEngagementDeclineNoticeDismissalStreakDetector {
  const WeeklyReportEngagementDeclineNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された見直し提案の
  /// 回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
