/// `SpacedReviewOverdueBacklogAlert`による間隔反復復習の積み上がり
/// アラートが連続して無視され続けている状態を検知する純関数。
/// `SpacedReviewOverdueBacklogAlert`自体は復習期限到来件数の積み上がり
/// のみを見る単発判定であり、出した後にユーザーがどう反応したかは
/// 見ない。実際の「まとめて復習しよう」案内の表示方法の見直しはアプリ
/// 側の責務とする。
class SpacedReviewOverdueBacklogAlertDismissalStreakDetector {
  const SpacedReviewOverdueBacklogAlertDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された間隔反復
  /// 復習積み上がりアラートの回数）が[dismissalThreshold]以上であれば、
  /// 連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
