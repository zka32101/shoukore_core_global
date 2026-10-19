/// `EntitlementExpiryNotice`による課金期限切れ事前通知が連続して無視され
/// 続けている状態を検知する純関数。`EntitlementExpiryNotice`自体は通知
/// すべきかどうかの判定のみを行い、出した後にユーザーがどう反応したかは
/// 見ない。`EntitlementGracePeriodRepeatedUsageDetector`は失効後の猶予
/// 期間の利用パターンのみを見るため、失効前の事前通知への反応は見ない。
/// `EntitlementRestorePromptDismissalStreakDetector`は復元を促す別の
/// 通知への無視を見るものであり、期限切れ事前通知とは別物である。実際の
/// 通知方法の見直し案内はアプリ側の責務とする。
class EntitlementExpiryNoticeDismissalStreakDetector {
  const EntitlementExpiryNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された期限切れ
  /// 事前通知の回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
