import '../models/models.dart';

/// デイリーミッションの次回リセット時刻・リマインド時刻を計算する純関数。
/// `RegionalProfile.dailyResetHour`（地域ごとの設定値）駆動で、固定5:00には依存しない。
class DailyReminderPlanner {
  const DailyReminderPlanner(this.profile);

  final RegionalProfile profile;

  /// [now] 以降で直近の「ミッションリセット時刻」を返す。
  DateTime nextResetAt(DateTime now) {
    final candidate = DateTime.utc(now.year, now.month, now.day, profile.dailyResetHour);
    return candidate.isAfter(now) ? candidate : candidate.add(const Duration(days: 1));
  }

  /// リセットの[before]前にリマインド通知を送るべき時刻。
  DateTime reminderAt(DateTime now, {Duration before = const Duration(hours: 1)}) =>
      nextResetAt(now).subtract(before);
}
