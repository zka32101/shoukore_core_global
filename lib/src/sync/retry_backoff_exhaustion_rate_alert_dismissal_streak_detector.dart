/// `RetryBackoffExhaustionRateAlert`によるシステム的同期障害アラートが
/// 連続して無視され続けている状態を検知する純関数。
/// `RetryBackoffExhaustionRateAlert`自体は枯渇件数の割合のみを見る
/// 単発判定であり、出した後にユーザーがどう反応したかは見ない。実際の
/// サーバー状態の確認・メンテナンス通知の表示方法の見直しはアプリ側の
/// 責務とする。
class RetryBackoffExhaustionRateAlertDismissalStreakDetector {
  const RetryBackoffExhaustionRateAlertDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視されたシステム的
  /// 同期障害アラートの回数）が[dismissalThreshold]以上であれば、連続
  /// 無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
