/// 未解消の弱点ノートのうち、最も古くから更新されずに残っているものが
/// どれだけ放置されているかを検知する純関数。`WeakNoteBacklogSizeAlert`
/// は未解消件数の絶対数のみを見るため、個々のノートがいつから放置され
/// ているかは見ない。`WeakNoteBacklogGrowthRateAlert`は件数の増加ペース
/// のみを見るため、放置期間は見ない。実際の「最優先で確認しよう」案内
/// の表示はアプリ側の責務とする。
class WeakNoteBacklogOldestItemAgeAlert {
  const WeakNoteBacklogOldestItemAgeAlert({this.agePeriod = const Duration(days: 30)});

  /// 最終更新からこの期間を超えて放置されていれば警告対象とする。
  final Duration agePeriod;

  /// [oldestUnresolvedUpdatedAt]（未解消の弱点ノートのうち最も古い最終
  /// 更新時刻、未解消のノートが無ければ`null`）から[now]までの経過が
  /// [agePeriod]を超えていれば警告すべきと判定する。
  bool shouldAlert({required DateTime? oldestUnresolvedUpdatedAt, required DateTime now}) {
    if (oldestUnresolvedUpdatedAt == null) return false;
    return now.difference(oldestUnresolvedUpdatedAt) > agePeriod;
  }
}
