/// `StreakFreezeTokenWasteDetector`が検知した無駄遣いパターンが、
/// さらに深刻な域まで達しているかを判定する純関数。
/// `StreakFreezeTokenWasteDetector`自体は閾値を超えたかどうかの
/// 単発判定のみを見るため、どの程度深刻かは見ない。実際の案内の
/// 強さの切り分けはアプリ側の責務とする。
class StreakFreezeTokenWasteSeverityDetector {
  const StreakFreezeTokenWasteSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveUnusedExpiryCount]（直近から連続して未使用のまま
  /// 失効した回数）が[severeThreshold]以上であれば、深刻な状態と
  /// 判定する。
  bool isSevere(int consecutiveUnusedExpiryCount) {
    return consecutiveUnusedExpiryCount >= severeThreshold;
  }
}
