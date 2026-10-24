/// `StreakFreezeTokenWasteDetector`が無駄遣いと判定する閾値にまだ到達
/// していないが、あと少しで到達しそうな状態を検知する純関数。
/// `StreakFreezeTokenWasteDetector`自体は閾値到達後のみを判定し、到達
/// 前の接近状態自体は見ない。実際の早期の「トークンを使おう」案内の
/// 表示はアプリ側の責務とする。
class StreakFreezeTokenWasteApproachingDetector {
  const StreakFreezeTokenWasteApproachingDetector({this.marginRatio = 0.2})
      : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveExpiredUnusedCount]（直近から連続して未使用のまま
  /// 失効したトークンの回数）が[wasteThreshold]未満かつ、
  /// [wasteThreshold] * (1 - [marginRatio])以上であれば、接近状態と
  /// 判定する。
  bool isApproaching({
    required int consecutiveExpiredUnusedCount,
    required int wasteThreshold,
  }) {
    if (consecutiveExpiredUnusedCount >= wasteThreshold) {
      return false;
    }
    final marginStart = (wasteThreshold * (1 - marginRatio)).ceil();
    return consecutiveExpiredUnusedCount >= marginStart;
  }
}
