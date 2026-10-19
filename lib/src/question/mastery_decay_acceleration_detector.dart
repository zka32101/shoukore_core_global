/// `MasteryDecay`による減衰量が複数回の確認にわたって悪化（増大）し続け
/// ている状態を検知する純関数。`MasteryRapidDecayDetector`は1回の減衰量
/// が大きいかどうかの単発判定のみを行うため、減衰量自体が悪化トレンド
/// にあるかは見ない。実際の学習ペースの見直し案内はアプリ側の責務と
/// する。
class MasteryDecayAccelerationDetector {
  const MasteryDecayAccelerationDetector({this.worseningStreakThreshold = 3})
      : assert(worseningStreakThreshold > 0);

  /// 連続して悪化がこの回数以上になったら検知対象とみなす。
  final int worseningStreakThreshold;

  /// [consecutiveWorseningCheckCount]（直近から連続して前回より減衰量が
  /// 増大した確認回数）が[worseningStreakThreshold]以上であれば、
  /// 悪化トレンドにあると判定する。
  bool isAccelerating(int consecutiveWorseningCheckCount) {
    return consecutiveWorseningCheckCount >= worseningStreakThreshold;
  }
}
