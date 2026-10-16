import 'daily_boundary.dart';

/// 地域の祝日・休校日に`DailyMission`を強制せず、未達成でもストリークや
/// 報酬未達成として扱わなくてよいかを判定する純関数。祝日データ自体の
/// 取得・保持は`RegionalProfile`に持たせず、アプリ側が渡す祝日一覧
/// （[holidays]、ミッション日単位の日付集合）と照合するだけの軽量な
/// 手がかりとする。実際のミッション未達成時の扱い（通知抑制、UI表示等）
/// はアプリ側の責務とする。
class RegionalHolidayMissionSkip {
  const RegionalHolidayMissionSkip();

  /// [now]が属するミッション日が[holidays]に含まれていれば、その日は
  /// ミッション未達成を見逃してよい（スキップ対象）と判定する。
  bool isSkippable({
    required DateTime now,
    required DailyBoundary boundary,
    required Set<DateTime> holidays,
  }) {
    final today = boundary.missionDayOf(now);
    return holidays.any((holiday) => boundary.missionDayOf(holiday) == today);
  }
}
