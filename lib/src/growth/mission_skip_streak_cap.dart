/// `RegionalHolidayMissionSkip`等によるミッション未達成の見逃しが連続
/// しすぎた場合、それ以上は`LearningStreak`の継続扱いの対象外にすべきかを
/// 判定する純関数。祝日等の見逃しが延々と連続するとストリークの意味が
/// 失われるため、上限を設ける。実際のストリーク更新処理自体はアプリ側の
/// 責務とする。
class MissionSkipStreakCap {
  const MissionSkipStreakCap({this.maxConsecutiveSkips = 7});

  /// 見逃しを連続で許容する最大日数。これを超えると継続扱いの対象外。
  final int maxConsecutiveSkips;

  /// [consecutiveSkippedDays]（直近まで連続でスキップ扱いになった日数）が
  /// [maxConsecutiveSkips]以上であれば、ストリーク継続の対象外と判定する。
  bool exceedsCap(int consecutiveSkippedDays) {
    return consecutiveSkippedDays >= maxConsecutiveSkips;
  }
}
