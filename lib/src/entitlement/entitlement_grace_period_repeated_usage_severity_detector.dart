/// `EntitlementGracePeriodRepeatedUsageDetector`が検知した繰り返し
/// 利用パターンが、さらに深刻な域まで達しているかを判定する純関数。
/// `EntitlementGracePeriodRepeatedUsageDetector`自体は閾値を超えた
/// かどうかの単発判定のみを見るため、どの程度深刻かは見ない。実際
/// の案内の強さの切り分けはアプリ側の責務とする。
class EntitlementGracePeriodRepeatedUsageSeverityDetector {
  const EntitlementGracePeriodRepeatedUsageSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveGracePeriodUsageCount]（直近から連続して猶予期間が
  /// 使用された課金サイクルの回数）が[severeThreshold]以上であれば、
  /// 深刻な状態と判定する。
  bool isSevere(int consecutiveGracePeriodUsageCount) {
    return consecutiveGracePeriodUsageCount >= severeThreshold;
  }
}
