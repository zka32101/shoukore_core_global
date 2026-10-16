/// セッション中の解答時間が徐々に遅くなっている（集中力低下の疑いがある）
/// かを判定する純関数。`AnswerLatencyOutlierFlag`（個々の解答の異常値）
/// とは異なり、本クラスは直近の解答時間列の前半と後半の平均を比較し、
/// 遅くなる傾向自体を見る。実際の休憩提案・通知はアプリ側の責務とする。
class AnswerLatencyFatigueTrend {
  const AnswerLatencyFatigueTrend({
    this.minimumSampleSize = 6,
    this.slowdownRatioThreshold = 1.5,
  }) : assert(minimumSampleSize >= 2);

  /// 判定に必要な最小解答件数。これ未満なら判定しない。
  final int minimumSampleSize;

  /// 後半の平均解答時間が前半の平均のこの倍以上であれば低下傾向とみなす。
  final double slowdownRatioThreshold;

  /// [latenciesOldestFirst]（古い順の解答時間列）を前半・後半に分け、
  /// 後半の平均が前半の平均の[slowdownRatioThreshold]倍以上であれば
  /// 集中力低下の疑いがあると判定する。
  bool isSlowingDown(List<Duration> latenciesOldestFirst) {
    if (latenciesOldestFirst.length < minimumSampleSize) return false;

    final half = latenciesOldestFirst.length ~/ 2;
    final firstHalf = latenciesOldestFirst.sublist(0, half);
    final secondHalf = latenciesOldestFirst.sublist(latenciesOldestFirst.length - half);

    final firstAverage = _averageMicroseconds(firstHalf);
    if (firstAverage == 0) return false;
    final secondAverage = _averageMicroseconds(secondHalf);

    return secondAverage / firstAverage >= slowdownRatioThreshold;
  }

  double _averageMicroseconds(List<Duration> durations) {
    final total = durations.fold<int>(0, (sum, d) => sum + d.inMicroseconds);
    return total / durations.length;
  }
}
