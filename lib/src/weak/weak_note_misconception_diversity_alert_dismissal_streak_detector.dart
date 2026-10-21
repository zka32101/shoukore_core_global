/// `WeakNoteMisconceptionDiversityAlert`による誤解多様化アラートが連続
/// して無視され続けている状態を検知する純関数。
/// `WeakNoteMisconceptionDiversityAlert`自体は誤解タイプの種類数のみを
/// 見る単発判定であり、出した後にユーザーがどう反応したかは見ない。
/// 実際の「基礎から見直そう」案内の表示方法の見直しはアプリ側の責務と
/// する。
class WeakNoteMisconceptionDiversityAlertDismissalStreakDetector {
  const WeakNoteMisconceptionDiversityAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された多様化
  /// アラートの回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
