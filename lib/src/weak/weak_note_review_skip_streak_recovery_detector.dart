/// `WeakNoteReviewSkipStreakDetector`が検知した復習セッションの連続
/// スキップ状態が解消し、連続して復習が実施されるようになったと判定
/// され続けているかを判定する純関数。
/// `WeakNoteReviewSkipStreakDetector`自体は連続スキップの有無のみを
/// 見る単発判定であり、解消の確認自体は見ない。実際のリマインド強化
/// ・出題への優先的な混在の解除方法はアプリ側の責務とする。
class WeakNoteReviewSkipStreakRecoveryDetector {
  const WeakNoteReviewSkipStreakRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveCompletedCount]（直近から連続して実施された復習
  /// セッションの回数）が[recoveryThreshold]以上であれば、解消状態と
  /// 判定する。
  bool isRecovered(int consecutiveCompletedCount) {
    return consecutiveCompletedCount >= recoveryThreshold;
  }
}
