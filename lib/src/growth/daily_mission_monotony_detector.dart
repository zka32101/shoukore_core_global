/// デイリーミッションが同じ種類ばかり連続して出題されている
/// マンネリ化状態を検知する純関数。`MissionSkipStreakCap`は未達成の
/// 見逃しの連続回数のみを見るため、達成しているかどうかに関わらず
/// 種類が偏っているかどうかは見ない。実際のミッション種類の選定ロジック
/// 自体はアプリ側の責務とする。
class DailyMissionMonotonyDetector {
  const DailyMissionMonotonyDetector({this.monotonyThreshold = 5});

  /// 同じ種類が何日連続すればマンネリ化とみなすか。
  final int monotonyThreshold;

  /// [recentMissionTypesNewestFirst]（直近のミッション種類識別子、新しい順）
  /// の先頭から[monotonyThreshold]件が全て同じ種類であれば、マンネリ化と
  /// 判定する。件数が[monotonyThreshold]未満の場合は`false`を返す。
  bool isMonotonous(List<String> recentMissionTypesNewestFirst) {
    if (recentMissionTypesNewestFirst.length < monotonyThreshold) return false;
    final recent = recentMissionTypesNewestFirst.take(monotonyThreshold);
    return recent.toSet().length == 1;
  }
}
