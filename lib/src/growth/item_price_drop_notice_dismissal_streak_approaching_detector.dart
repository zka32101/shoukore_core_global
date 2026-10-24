/// `ItemPriceDropNoticeDismissalStreakDetector`が連続無視状態と判定
/// する閾値にまだ到達していないが、あと少しで到達しそうな状態を検知
/// する純関数。
/// `ItemPriceDropNoticeDismissalStreakDetector`自体は閾値到達後の
/// みを判定し、到達前の接近状態自体は見ない。実際の早期の表示方法の
/// 見直し案内はアプリ側の責務とする。
class ItemPriceDropNoticeDismissalStreakApproachingDetector {
  const ItemPriceDropNoticeDismissalStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveDismissalCount]（直近から連続して無視された値下げ通知の
  /// 回数）が[dismissalThreshold]未満かつ、
  /// [dismissalThreshold] * (1 - [marginRatio])以上であれば、接近状態
  /// と判定する。
  bool isApproaching({
    required int consecutiveDismissalCount,
    required int dismissalThreshold,
  }) {
    if (consecutiveDismissalCount >= dismissalThreshold) {
      return false;
    }
    final marginStart = (dismissalThreshold * (1 - marginRatio)).ceil();
    return consecutiveDismissalCount >= marginStart;
  }
}
