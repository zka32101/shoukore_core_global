/// 端末のタイムゾーンが前回記録時と変わっていないかを検出する純関数。
/// 海外旅行・OS設定変更等によるタイムゾーン変更は、`DailyBoundary`の
/// 日付境界判定を乱す可能性があるため、その手がかりとして使う。実際の
/// タイムゾーン取得（`DateTime.now().timeZoneName`等）・記録の永続化・
/// 変更時の対応（再確認ダイアログ等）はアプリ側の責務とする。
class TimeZoneDriftDetector {
  const TimeZoneDriftDetector();

  /// [lastRecordedTimeZone]（前回記録したタイムゾーン識別子、未記録は
  /// `null`）と[currentTimeZone]（現在のタイムゾーン識別子）を比較し、
  /// 変化していれば`true`を返す。未記録の場合は変化なしとして`false`を
  /// 返す（初回起動時に毎回「変更あり」と判定されるのを避ける）。
  bool hasDrifted({required String? lastRecordedTimeZone, required String currentTimeZone}) {
    if (lastRecordedTimeZone == null) return false;
    return lastRecordedTimeZone != currentTimeZone;
  }
}
