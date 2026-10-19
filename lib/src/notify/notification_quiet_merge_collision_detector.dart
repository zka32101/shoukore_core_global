/// `NotificationQuietMerge`によって静かな時間帯明け直後に再スケジュール
/// された複数の通知が、結果として同じ解決後の時刻に集中（衝突）して
/// いないかを判定する純関数。`NotificationQuietMerge`自体は1件ごとの
/// 再スケジュール先の算出のみを行い、他の通知との衝突は見ない。
/// `NotificationScheduleClusteringDetector`はマージ前の生スケジュールの
/// 密集のみを見るため、マージ後に新たに生じる衝突は見ない。実際の
/// 再スケジュール時刻の分散処理はアプリ側の責務とする。
class NotificationQuietMergeCollisionDetector {
  const NotificationQuietMergeCollisionDetector({this.collisionThreshold = 3})
      : assert(collisionThreshold > 1);

  /// 同一時刻に解決された通知数がこの件数以上であれば衝突とみなす。
  final int collisionThreshold;

  /// [resolvedAtTimes]（`NotificationQuietMerge.resolve`で算出された、
  /// 各通知の解決後時刻の一覧）のうち、同一時刻が[collisionThreshold]件
  /// 以上存在すれば衝突と判定する。
  bool hasCollision(List<DateTime> resolvedAtTimes) {
    final counts = <DateTime, int>{};
    for (final at in resolvedAtTimes) {
      counts[at] = (counts[at] ?? 0) + 1;
      if (counts[at]! >= collisionThreshold) return true;
    }
    return false;
  }
}
