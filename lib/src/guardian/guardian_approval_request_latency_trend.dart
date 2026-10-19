/// 保護者承認申請が応答（承認/却下）されるまでの所要時間の履歴から、
/// 応答までの時間が悪化傾向にあるかを判定する純関数。
/// `GuardianApprovalRequestBacklogSizeAlert`は承認待ちの件数の積み上がり
/// のみを見るため応答速度の変化は見ない。`GuardianApprovalRequestStaleRejectionReminder`
/// は却下後に再提出がなく放置されているかのみを見るため、応答そのものの
/// 速さは見ない。実際の傾向表示・保護者への通知はアプリ側の責務とする。
class GuardianApprovalRequestLatencyTrend {
  const GuardianApprovalRequestLatencyTrend({
    this.recentWindowSize = 3,
    this.worseningRatioThreshold = 1.5,
  }) : assert(recentWindowSize > 0),
       assert(worseningRatioThreshold > 0);

  /// 直近として比較する件数。
  final int recentWindowSize;

  /// 直近平均が以前平均のこの倍以上であれば悪化傾向とみなす。
  final double worseningRatioThreshold;

  /// [responseLatenciesOldestFirst]（申請から応答までの所要時間、古い順）
  /// の直近[recentWindowSize]件の平均が、それより前の平均の
  /// [worseningRatioThreshold]倍以上であれば悪化傾向と判定する。
  /// 比較に十分な件数がない場合は`false`を返す。
  bool isWorsening(List<Duration> responseLatenciesOldestFirst) {
    if (responseLatenciesOldestFirst.length <= recentWindowSize) return false;

    final olderCount = responseLatenciesOldestFirst.length - recentWindowSize;
    final older = responseLatenciesOldestFirst.take(olderCount);
    final recent = responseLatenciesOldestFirst.skip(olderCount);

    final olderAverage = _averageMicroseconds(older);
    if (olderAverage <= 0) return false;
    final recentAverage = _averageMicroseconds(recent);

    return recentAverage >= olderAverage * worseningRatioThreshold;
  }

  double _averageMicroseconds(Iterable<Duration> durations) {
    final list = durations.toList();
    if (list.isEmpty) return 0;
    final total = list.fold<int>(0, (sum, d) => sum + d.inMicroseconds);
    return total / list.length;
  }
}
