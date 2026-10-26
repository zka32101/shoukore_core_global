/// `StreakRecoveryGraceRepeatedUsageDetector`が検知した繰り返し
/// 利用パターンが、さらに深刻な域まで達しているかを判定する純
/// 関数。`StreakRecoveryGraceRepeatedUsageDetector`自体は閾値を
/// 超えたかどうかの単発判定のみを見るため、どの程度深刻かは見
/// ない。実際の案内の強さの切り分けはアプリ側の責務とする。
class StreakRecoveryGraceRepeatedUsageSeverityDetector {
  const StreakRecoveryGraceRepeatedUsageSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveGraceUsageCount]（直近から連続して見逃し猶予が
  /// 使われた回数）が[severeThreshold]以上であれば、深刻な状態と
  /// 判定する。
  bool isSevere(int consecutiveGraceUsageCount) {
    return consecutiveGraceUsageCount >= severeThreshold;
  }
}
