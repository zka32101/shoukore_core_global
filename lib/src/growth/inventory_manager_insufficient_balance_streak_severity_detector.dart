/// `InventoryManagerInsufficientBalanceStreakDetector`が検知した
/// 連続残高不足パターンが、さらに深刻な域まで達しているかを判定
/// する純関数。`InventoryManagerInsufficientBalanceStreakDetector`
/// 自体は閾値を超えたかどうかの単発判定のみを見るため、どの程度
/// 深刻かは見ない。実際の案内の強さの切り分けはアプリ側の責務
/// とする。
class InventoryManagerInsufficientBalanceStreakSeverityDetector {
  const InventoryManagerInsufficientBalanceStreakSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveInsufficientBalanceCount]（直近から連続して残高
  /// 不足が発生した回数）が[severeThreshold]以上であれば、深刻な
  /// 状態と判定する。
  bool isSevere(int consecutiveInsufficientBalanceCount) {
    return consecutiveInsufficientBalanceCount >= severeThreshold;
  }
}
