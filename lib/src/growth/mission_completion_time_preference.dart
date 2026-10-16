/// ミッション達成（学習完了）の履歴から、子どもが最も学習しやすい
/// 時間帯（1日のうちどの時間が多いか）を推定する純関数。通知タイミング
/// の最適化に使うことを想定し、本クラスは時刻の集計のみを行う。実際の
/// 通知スケジューリングはアプリ側の責務とする。
class MissionCompletionTimePreference {
  const MissionCompletionTimePreference({this.minimumSampleSize = 5});

  /// 推定に必要な最小件数。これ未満なら推定しない。
  final int minimumSampleSize;

  /// [completedAtTimes]（ミッション達成時刻の履歴）を時（0-23）ごとに
  /// 集計し、最も件数が多い時を返す。件数が[minimumSampleSize]未満、
  /// または履歴が空の場合は`null`を返す。複数の時が同数で最多の場合は
  /// そのうち最も早い時を返す。
  int? mostFrequentHour(List<DateTime> completedAtTimes) {
    if (completedAtTimes.length < minimumSampleSize) return null;

    final countsByHour = <int, int>{};
    for (final time in completedAtTimes) {
      countsByHour[time.hour] = (countsByHour[time.hour] ?? 0) + 1;
    }

    var bestHour = 0;
    var bestCount = -1;
    for (var hour = 0; hour < 24; hour++) {
      final count = countsByHour[hour] ?? 0;
      if (count > bestCount) {
        bestCount = count;
        bestHour = hour;
      }
    }
    return bestHour;
  }
}
