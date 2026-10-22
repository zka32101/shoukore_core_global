/// `NotificationQuietMergeCollisionDetector`が静かな時間帯明けの再
/// スケジュールによる通知の衝突を検知した結果が、単発ではなくマージの
/// たびに繰り返し検出され続けているかを判定する純関数。
/// `NotificationQuietMergeCollisionDetector`自体は1回のマージ処理内での
/// 衝突のみを見るため、衝突の発生自体が繰り返されているかは見ない。
/// 実際の再スケジュール時刻の分散処理の見直しはアプリ側の責務とする。
class NotificationQuietMergeCollisionRecurrenceDetector {
  const NotificationQuietMergeCollisionRecurrenceDetector({
    this.recurrenceThreshold = 3,
  }) : assert(recurrenceThreshold > 0);

  final int recurrenceThreshold;

  bool isRecurring(int consecutiveCollisionCount) {
    return consecutiveCollisionCount >= recurrenceThreshold;
  }
}
