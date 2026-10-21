/// `WeakNoteBacklogSizeAlert`による弱点ノート積み上がりアラートが連続
/// して無視され続けている状態を検知する純関数。`WeakNoteBacklogSizeAlert`
/// 自体は未解消件数のみを見る単発判定であり、出した後にユーザーがどう
/// 反応したかは見ない。実際の「まとめて復習しよう」案内の表示方法の
/// 見直しはアプリ側の責務とする。
class WeakNoteBacklogSizeAlertDismissalStreakDetector {
  const WeakNoteBacklogSizeAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された弱点ノート
  /// 積み上がりアラートの回数）が[dismissalThreshold]以上であれば、
  /// 連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
