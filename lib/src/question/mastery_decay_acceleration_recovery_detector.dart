/// `MasteryDecayAccelerationDetector`が検知した減衰量の悪化トレンドが
/// 解消し、連続して減衰量が悪化しなくなったと判定され続けているかを
/// 判定する純関数。
/// `MasteryDecayAccelerationDetector`自体は悪化トレンドの有無のみを
/// 見る単発判定であり、解消の確認自体は見ない。実際の学習ペースの
/// 見直し案内の解除方法はアプリ側の責務とする。
class MasteryDecayAccelerationRecoveryDetector {
  const MasteryDecayAccelerationRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveNonWorseningCheckCount]（直近から連続して減衰量が
  /// 悪化しなかった確認回数）が[recoveryThreshold]以上であれば、解消
  /// 状態と判定する。
  bool isRecovered(int consecutiveNonWorseningCheckCount) {
    return consecutiveNonWorseningCheckCount >= recoveryThreshold;
  }
}
