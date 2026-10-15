/// 1日のうちの「静かな時間帯」を`hour`/`minute`（0-23/0-59）で表す。
class TimeOfDay {
  const TimeOfDay({required this.hour, required this.minute})
    : assert(hour >= 0 && hour <= 23),
      assert(minute >= 0 && minute <= 59);

  final int hour;
  final int minute;

  int get _minutesFromMidnight => hour * 60 + minute;
}

/// 保護者が設定した時間帯（就寝時間など）の間は、新規ミッション開始や通知を
/// 控えるべきかどうかを判定する純関数。`start`が`end`より後の場合は日をまたぐ
/// 範囲（例: 21:00〜翌7:00）として扱う。`ScreenTimeGuard`（累積利用時間の制限）
/// とは独立した、時刻帯ベースの制限を提供する。
class QuietHoursGuard {
  const QuietHoursGuard({required this.start, required this.end});

  final TimeOfDay start;
  final TimeOfDay end;

  /// [now]が静かな時間帯に含まれるかどうかを判定する。
  bool isQuietAt(DateTime now) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start._minutesFromMidnight;
    final endMinutes = end._minutesFromMidnight;

    if (startMinutes == endMinutes) {
      return false;
    }
    if (startMinutes < endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    }
    // 日をまたぐ範囲（例: 21:00〜翌7:00）。
    return nowMinutes >= startMinutes || nowMinutes < endMinutes;
  }
}
