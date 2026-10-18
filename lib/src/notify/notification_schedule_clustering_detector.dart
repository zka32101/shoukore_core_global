import 'duplicate_notification_schedule_detector.dart';

/// 複数の通知予定が、内容の異同に関わらず短時間の範囲内に密集して
/// スケジュールされている状態を検知する純関数。
/// `DuplicateNotificationScheduleDetector`は同一内容の通知の重複のみを
/// 見るため、異なる内容の通知が密集しているかは見ない。`NotificationQuietMerge`
/// は静かな時間帯の再スケジュール先の算出のみを行う。実際の通知の間引き・
/// 時間分散の実行はアプリ側の責務とする。
class NotificationScheduleClusteringDetector {
  const NotificationScheduleClusteringDetector({
    this.clusterWindow = const Duration(minutes: 10),
    this.clusterThreshold = 3,
  }) : assert(clusterThreshold > 1);

  /// この時間範囲内に予約された通知を同一クラスターとみなす。
  final Duration clusterWindow;

  /// 1クラスター内の通知数がこの件数以上であれば密集とみなす。
  final int clusterThreshold;

  /// [scheduled]のうち、[clusterWindow]以内に[clusterThreshold]件以上の
  /// 通知が密集している箇所が存在するかを判定する。
  bool isClustered(List<NotificationScheduleEntry> scheduled) {
    if (scheduled.length < clusterThreshold) return false;

    final sorted = [...scheduled]..sort((a, b) => a.at.compareTo(b.at));
    for (var i = 0; i <= sorted.length - clusterThreshold; i++) {
      final windowEnd = sorted[i].at.add(clusterWindow);
      if (!sorted[i + clusterThreshold - 1].at.isAfter(windowEnd)) {
        return true;
      }
    }
    return false;
  }
}
