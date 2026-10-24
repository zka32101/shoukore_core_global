/// `WeakNoteReviewSkipStreakDetector`が連続スキップ状態と判定する
/// 閾値にまだ到達していないが、あと少しで到達しそうな状態を検知する
/// 純関数。`WeakNoteReviewSkipStreakDetector`自体は閾値到達後のみを
/// 判定し、到達前の接近状態自体は見ない。実際の早期のリマインド強化・
/// 出題への優先的な混在はアプリ側の責務とする。
class WeakNoteReviewSkipStreakApproachingDetector {
  const WeakNoteReviewSkipStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveSkipCount]（直近から連続してスキップされた復習セッション
  /// の回数）が[skipThreshold]未満かつ、
  /// [skipThreshold] * (1 - [marginRatio])以上であれば、接近状態と
  /// 判定する。
  bool isApproaching({
    required int consecutiveSkipCount,
    required int skipThreshold,
  }) {
    if (consecutiveSkipCount >= skipThreshold) {
      return false;
    }
    final marginStart = (skipThreshold * (1 - marginRatio)).ceil();
    return consecutiveSkipCount >= marginStart;
  }
}
