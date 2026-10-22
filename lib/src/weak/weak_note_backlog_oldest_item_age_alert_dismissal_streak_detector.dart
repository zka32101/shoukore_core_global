/// `WeakNoteBacklogOldestItemAgeAlert`による最古弱点ノート放置アラート
/// が連続して無視され続けている状態を検知する純関数。
/// `WeakNoteBacklogOldestItemAgeAlert`自体は未解消の弱点ノートのうち
/// 最も古いものの放置期間のみを見る単発判定であり、出した後にユーザー
/// がどう反応したかは見ない。実際の「最優先で確認しよう」案内の表示
/// 方法の見直しはアプリ側の責務とする。
class WeakNoteBacklogOldestItemAgeAlertDismissalStreakDetector {
  const WeakNoteBacklogOldestItemAgeAlertDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された最古弱点
  /// ノート放置アラートの回数）が[dismissalThreshold]以上であれば、
  /// 連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
