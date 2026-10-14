import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global_notify.dart';

void main() {
  // flutter_local_notificationsの実際の通知呼び出しはプラットフォームプラグインの
  // 登録（Android/iOS実機・エミュレータでのプラグイン登録メカニズム）に依存するため、
  // CIのdart VM環境では検証できない（結合確認はexample/または実機テストの責務）。
  // ここではコンストラクタ・デフォルト値といった純粋なロジック部分のみ検証する。
  test('既定のchannelId/channelNameを持つ', () {
    final scheduler = LocalNotificationScheduler(FlutterLocalNotificationsPlugin());
    expect(scheduler.channelId, 'shoukore_core_global_daily');
    expect(scheduler.channelName, 'Daily reminders');
  });

  test('channelId/channelNameを差し替えられる', () {
    final scheduler = LocalNotificationScheduler(
      FlutterLocalNotificationsPlugin(),
      channelId: 'custom_channel',
      channelName: 'Custom',
    );
    expect(scheduler.channelId, 'custom_channel');
    expect(scheduler.channelName, 'Custom');
  });
}
