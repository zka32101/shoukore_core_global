/// `NotificationQuietMergeCollisionDetector`が検知した静かな時間帯明け
/// 後の通知の衝突が解消し、連続して衝突なしと判定され続けているかを
/// 判定する純関数。`NotificationQuietMergeCollisionDetector`自体は
/// 1回のマージ処理内での衝突のみを見る単発判定であり、解消の確認自体
/// は見ない。`NotificationQuietMergeCollisionRecurrenceDetector`は衝突
/// が繰り返されているかを見るもので、本クラスはその逆軸（解消の確認）
/// を見る。実際の再スケジュール時刻の分散処理の解除方法の見直しは
/// アプリ側の責務とする。
class NotificationQuietMergeCollisionRecoveryDetector {
  const NotificationQuietMergeCollisionRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonCollisionCount) {
    return consecutiveNonCollisionCount >= recoveryThreshold;
  }
}
