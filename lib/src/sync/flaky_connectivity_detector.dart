/// 短時間だけオンラインになってすぐオフラインに戻るパターンが頻発して
/// いる、不安定な接続状態を検知する純関数。`OfflineSessionGapDetector`は
/// 長時間オフラインのギャップのみを見るため、短いオンライン区間が繰り返
/// されているパターンは見ない。実際のオフライン専用モードの提案はアプリ
/// 側の責務とする。
class FlakyConnectivityDetector {
  const FlakyConnectivityDetector({
    this.shortOnlineDuration = const Duration(seconds: 30),
    this.flakyOccurrenceThreshold = 3,
  });

  /// オンライン区間がこの時間未満であれば短いオンラインとみなす。
  final Duration shortOnlineDuration;

  /// 短いオンライン区間がこの回数以上連続すれば不安定とみなす。
  final int flakyOccurrenceThreshold;

  /// [recentOnlineDurationsNewestFirst]（直近のオンライン継続時間、新しい
  /// 順）の先頭から[flakyOccurrenceThreshold]件全てが[shortOnlineDuration]
  /// 未満であれば、不安定な接続状態と判定する。
  bool isFlaky(List<Duration> recentOnlineDurationsNewestFirst) {
    if (recentOnlineDurationsNewestFirst.length < flakyOccurrenceThreshold) return false;
    return recentOnlineDurationsNewestFirst
        .take(flakyOccurrenceThreshold)
        .every((duration) => duration < shortOnlineDuration);
  }
}
