/// 直近の解答時間が継続的に短縮している（習熟が進んでいる疑いがある）
/// かを判定する純関数。`AnswerLatencyFatigueTrend`は解答時間が遅くなる
/// 方向の悪化傾向のみを見るため、短縮方向の改善傾向は見ない。実際の
/// 難易度調整の提案・称賛表示はアプリ側の責務とする。
class AnswerLatencyImprovementTrendDetector {
  const AnswerLatencyImprovementTrendDetector({
    this.minimumSampleSize = 6,
    this.speedupRatioThreshold = 0.7,
  }) : assert(minimumSampleSize >= 2);

  /// 判定に必要な最小解答件数。これ未満なら判定しない。
  final int minimumSampleSize;

  /// 後半の平均解答時間が前半の平均のこの倍以下であれば短縮傾向とみなす。
  final double speedupRatioThreshold;

  /// [latenciesOldestFirst]（古い順の解答時間列）を前半・後半に分け、
  /// 後半の平均が前半の平均の[speedupRatioThreshold]倍以下であれば
  /// 習熟が進んでいる疑いがあると判定する。
  bool isImproving(List<Duration> latenciesOldestFirst) {
    if (latenciesOldestFirst.length < minimumSampleSize) return false;

    final half = latenciesOldestFirst.length ~/ 2;
    final firstHalf = latenciesOldestFirst.sublist(0, half);
    final secondHalf = latenciesOldestFirst.sublist(latenciesOldestFirst.length - half);

    final firstAverage = _averageMicroseconds(firstHalf);
    if (firstAverage == 0) return false;
    final secondAverage = _averageMicroseconds(secondHalf);

    return secondAverage / firstAverage <= speedupRatioThreshold;
  }

  double _averageMicroseconds(List<Duration> durations) {
    final total = durations.fold<int>(0, (sum, d) => sum + d.inMicroseconds);
    return total / durations.length;
  }
}
