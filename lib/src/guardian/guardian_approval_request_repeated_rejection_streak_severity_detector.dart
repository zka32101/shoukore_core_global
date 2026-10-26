/// `GuardianApprovalRequestRepeatedRejectionStreakDetector`が検知した
/// 連続拒否パターンが、さらに深刻な域まで達しているかを判定する
/// 純関数。`GuardianApprovalRequestRepeatedRejectionStreakDetector`
/// 自体は閾値を超えたかどうかの単発判定のみを見るため、どの程度
/// 深刻かは見ない。実際の案内の強さの切り分けはアプリ側の責務
/// とする。
class GuardianApprovalRequestRepeatedRejectionStreakSeverityDetector {
  const GuardianApprovalRequestRepeatedRejectionStreakSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveRejectionCount]（直近から連続して承認リクエストが
  /// 拒否された回数）が[severeThreshold]以上であれば、深刻な状態と
  /// 判定する。
  bool isSevere(int consecutiveRejectionCount) {
    return consecutiveRejectionCount >= severeThreshold;
  }
}
