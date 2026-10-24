/// `NotificationScheduleClusteringDetector`が検知した通知予定の密集状態が
/// 解消し、連続して密集なしと判定され続けているかを判定する純関数。
/// `NotificationScheduleClusteringDetector`自体は1回のスケジュール集合内
/// での密集のみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 通知の間引き・時間分散の実行方法の見直しはアプリ側の責務とする。
class NotificationScheduleClusteringRecoveryDetector {
  const NotificationScheduleClusteringRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonClusteredCount) {
    return consecutiveNonClusteredCount >= recoveryThreshold;
  }
}
