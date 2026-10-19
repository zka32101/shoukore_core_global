/// `WeakNotesReviewScheduler`が提示した復習セッションが連続してスキップ
/// されている状態を検知する純関数。`WeakNoteReviewOverdueEscalation`は
/// 復習期限からの放置期間のみを見るため、提示されたセッション自体が
/// 何回連続でスキップされたかは見ない。`MissionSkipStreakCap`は日次
/// ミッション領域の連続スキップを扱うため、弱点ノートの復習セッションは
/// 対象外。実際のリマインド強化・出題への優先的な混在はアプリ側の責務
/// とする。
class WeakNoteReviewSkipStreakDetector {
  const WeakNoteReviewSkipStreakDetector({this.skipThreshold = 3});

  /// 連続スキップがこの回数以上になったら検知対象とみなす。
  final int skipThreshold;

  /// [consecutiveSkipCount]（直近から連続してスキップされた復習セッション
  /// の回数）が[skipThreshold]以上であれば、連続スキップ状態と判定する。
  bool isPersistentlySkipped(int consecutiveSkipCount) {
    return consecutiveSkipCount >= skipThreshold;
  }
}
