/// `GuardianDeliveryFailureAlternativeNotice`による代替通知手段の提案が
/// 連続して無視され続けている状態を検知する純関数。
/// `GuardianDeliveryFailureAlternativeNotice`自体は連続配信失敗回数のみを
/// 見る単発判定であり、出した後にユーザーがどう反応したかは見ない。
/// 実際の表示方法の見直し案内はアプリ側の責務とする。
class GuardianDeliveryFailureAlternativeNoticeDismissalStreakDetector {
  const GuardianDeliveryFailureAlternativeNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された代替通知手段
  /// 提案の回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
