/// `InventoryManagerInsufficientBalanceStreakDetector`が検知対象と判定
/// する閾値にまだ到達していないが、あと少しで到達しそうな状態を検知
/// する純関数。`InventoryManagerInsufficientBalanceStreakDetector`自体
/// は閾値到達後のみを判定し、到達前の接近状態自体は見ない。実際の
/// 早期の「コインを増やす方法」案内の表示はアプリ側の責務とする。
class InventoryManagerInsufficientBalanceStreakApproachingDetector {
  const InventoryManagerInsufficientBalanceStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveInsufficientBalanceCount]（直近から連続して残高不足で
  /// 購入できなかった試行の回数）が[streakThreshold]未満かつ、
  /// [streakThreshold] * (1 - [marginRatio])以上であれば、接近状態と
  /// 判定する。
  bool isApproaching({
    required int consecutiveInsufficientBalanceCount,
    required int streakThreshold,
  }) {
    if (consecutiveInsufficientBalanceCount >= streakThreshold) {
      return false;
    }
    final marginStart = (streakThreshold * (1 - marginRatio)).ceil();
    return consecutiveInsufficientBalanceCount >= marginStart;
  }
}
