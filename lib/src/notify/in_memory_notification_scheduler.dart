import 'notification_scheduler.dart';

class ScheduledNotification {
  const ScheduledNotification({
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

/// テスト・プロトタイプ用の `NotificationScheduler` 実装。実運用では
/// `flutter_local_notifications` 等のアダプタに置き換える（プッシュ(FCM)は使わない）。
class InMemoryNotificationScheduler implements NotificationScheduler {
  final Map<String, ScheduledNotification> _scheduled = {};

  Map<String, ScheduledNotification> get scheduled => Map.unmodifiable(_scheduled);

  @override
  Future<void> schedule({
    required String id,
    required DateTime at,
    required String titleKey,
    required String bodyKey,
  }) async {
    _scheduled[id] = ScheduledNotification(id: id, at: at, titleKey: titleKey, bodyKey: bodyKey);
  }

  @override
  Future<void> cancel(String id) async {
    _scheduled.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    _scheduled.clear();
  }
}
