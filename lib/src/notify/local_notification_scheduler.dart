import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_scheduler.dart';

/// `flutter_local_notifications` を使った既定実装。プッシュ(FCM)は使わず、
/// 端末内のローカル通知のみをスケジュールする。
///
/// `titleKey`/`bodyKey` はアプリ側がarb/ロケールで解決済みの表示文字列を渡す
/// ことを前提とする（`NotificationScheduler`抽象のコメント参照）。
class LocalNotificationScheduler implements NotificationScheduler {
  LocalNotificationScheduler(
    this._plugin, {
    this.channelId = 'shoukore_core_global_daily',
    this.channelName = 'Daily reminders',
  });

  final FlutterLocalNotificationsPlugin _plugin;
  final String channelId;
  final String channelName;

  /// 通知プラグインを初期化する。`schedule`を呼ぶ前にアプリ起動時に一度呼ぶこと。
  /// タイムゾーンデータベースの初期化（`tz.initializeTimeZones()`等）はアプリ側の責務。
  Future<void> initialize({
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher'),
    DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(),
  }) async {
    await _plugin.initialize(
      settings: InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  @override
  Future<void> schedule({
    required String id,
    required DateTime at,
    required String titleKey,
    required String bodyKey,
  }) async {
    await _plugin.zonedSchedule(
      id: id.hashCode,
      title: titleKey,
      body: bodyKey,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(channelId, channelName),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(String id) async {
    await _plugin.cancel(id: id.hashCode);
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
