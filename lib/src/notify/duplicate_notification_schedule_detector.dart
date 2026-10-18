/// `NotificationScheduler.schedule`に予約済みの通知1件分の最小情報。
class NotificationScheduleEntry {
  const NotificationScheduleEntry({
    required this.id,
    required this.at,
    required this.titleKey,
    required this.bodyKey,
  });

  final String id;
  final DateTime at;
  final String titleKey;
  final String bodyKey;
}

/// 同一内容（`titleKey`/`bodyKey`が一致）の通知が短時間内に複数予約されて
/// いないかを検知する純関数。`NotificationQuietMerge`（静かな時間帯に
/// 予定されていた通知の再スケジュール先の算出）とは異なり、本クラスは
/// 同一内容の通知が重複して積まれていること自体を見る。実際の重複通知の
/// キャンセル・統合処理はアプリ側の責務とする。
class DuplicateNotificationScheduleDetector {
  const DuplicateNotificationScheduleDetector({this.duplicateWindow = const Duration(minutes: 10)});

  /// この時間内に予約された、同一内容の通知を重複とみなす。
  final Duration duplicateWindow;

  /// [scheduled]（予約済みの通知一覧）のうち、[candidate]と同一の
  /// `titleKey`/`bodyKey`を持ち、`at`の差が[duplicateWindow]以内のものが
  /// 既に含まれていれば重複とみなす。
  bool isDuplicate({
    required NotificationScheduleEntry candidate,
    required Iterable<NotificationScheduleEntry> scheduled,
  }) {
    return scheduled.any((notification) {
      if (notification.id == candidate.id) return false;
      if (notification.titleKey != candidate.titleKey) return false;
      if (notification.bodyKey != candidate.bodyKey) return false;
      return notification.at.difference(candidate.at).abs() <= duplicateWindow;
    });
  }
}
