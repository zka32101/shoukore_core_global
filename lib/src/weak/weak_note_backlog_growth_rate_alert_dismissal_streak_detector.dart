/// `WeakNoteBacklogGrowthRateAlert`による弱点ノート急増アラートが連続
/// して無視され続けている状態を検知する純関数。
/// `WeakNoteBacklogGrowthRateAlert`自体は未解消件数の増加ペースのみを
/// 見る単発判定であり、出した後にユーザーがどう反応したかは見ない。
/// 実際の「まとめて復習しよう」案内の表示方法の見直しはアプリ側の
/// 責務とする。
class WeakNoteBacklogGrowthRateAlertDismissalStreakDetector {
  const WeakNoteBacklogGrowthRateAlertDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された弱点ノート
  /// 急増アラートの回数）が[dismissalThreshold]以上であれば、連続無視
  /// 状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
