import '../guardian/quiet_hours_guard.dart';

/// `QuietHoursGuard`の結果を踏まえ、静かな時間帯に予定されていた通知を、
/// 時間帯が明けた直後に再スケジュールすべきかを判定する純関数。
/// `NotificationScheduler`（実際の通知予約・発火）とは独立しており、
/// 「いつに変更すべきか」を計算するだけで、実際の再スケジュール処理
/// 自体はアプリ側の責務とする。
class NotificationQuietMerge {
  const NotificationQuietMerge(this.guard);

  final QuietHoursGuard guard;

  /// [scheduledAt]が静かな時間帯に含まれる場合、その時間帯が明ける時刻
  /// （`guard.end`の時刻）を返す。含まれない場合は[scheduledAt]をそのまま
  /// 返す（再スケジュール不要）。
  DateTime resolve(DateTime scheduledAt) {
    if (!guard.isQuietAt(scheduledAt)) return scheduledAt;

    var endAt = DateTime(
      scheduledAt.year,
      scheduledAt.month,
      scheduledAt.day,
      guard.end.hour,
      guard.end.minute,
    );
    // 日をまたぐ範囲（start > end）で、scheduledAtが深夜0時台〜endより前の
    // 場合は、endは同日中。それ以外（start以降〜日付終わり）の場合は、
    // endは翌日になる。
    if (!endAt.isAfter(scheduledAt)) {
      endAt = endAt.add(const Duration(days: 1));
    }
    return endAt;
  }
}
