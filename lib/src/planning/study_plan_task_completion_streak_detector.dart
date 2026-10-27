/// 学習計画タスクを期限内に連続して完了できているかを判定する
/// 純関数。既存のストリーク系検出器と同じ考え方を、計画タスクの
/// 継続達成に適用したもの。実際の継続表示・称賛演出自体はアプリ
/// 側の責務とする。
class StudyPlanTaskCompletionStreakDetector {
  const StudyPlanTaskCompletionStreakDetector({this.onTrackThreshold = 3})
      : assert(onTrackThreshold > 0);

  /// 「順調」とみなす連続期限内完了数の閾値。
  final int onTrackThreshold;

  /// [consecutiveOnTimeCompletionCount]（直近の連続期限内完了数）が
  /// [onTrackThreshold]以上であれば順調と判定する。
  bool isOnTrack(int consecutiveOnTimeCompletionCount) {
    return consecutiveOnTimeCompletionCount >= onTrackThreshold;
  }
}
