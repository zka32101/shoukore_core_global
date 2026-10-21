/// `SessionReviewModeRatioAlert`による復習モード偏りアラートが連続して
/// 無視され続けている状態を検知する純関数。`SessionReviewModeRatioAlert`
/// 自体はセッション内の復習モード比率のみを見る単発判定であり、出した
/// 後にユーザーがどう反応したかは見ない。実際の出題モード切り替え判断の
/// 見直しはアプリ側の責務とする。
class SessionReviewModeRatioAlertDismissalStreakDetector {
  const SessionReviewModeRatioAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された偏りアラート
  /// の回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
