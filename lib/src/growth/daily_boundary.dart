import '../clock/clock.dart';
import '../models/models.dart';

/// DailyMission等の「今日」の境界を計算する。固定5:00リセットは廃止し、
/// `RegionalProfile.dailyResetHour`（地域ごとの設定値）を使う。
/// タイムゾーン変換はアプリ側（`profile.timeZone`を使ったローカライズ）に委ね、
/// ここでは渡された[Clock]の時刻をそのまま地域のローカル時刻として扱う。
class DailyBoundary {
  const DailyBoundary(this.profile);

  final RegionalProfile profile;

  /// [at] が属するミッション日（リセット時刻を基準にした日付のみ）を返す。
  DateTime missionDayOf(DateTime at) {
    final shifted = at.subtract(Duration(hours: profile.dailyResetHour));
    return dateOnly(shifted);
  }

  /// 現在時刻が属するミッション日。
  DateTime currentMissionDay(Clock clock) => missionDayOf(clock.now());

  /// 2つの時刻が同じミッション日に属するか。
  bool isSameMissionDay(DateTime a, DateTime b) => missionDayOf(a) == missionDayOf(b);
}
