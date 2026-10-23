/// `MasteryAcrossUnitsStagnationDetector`が検知した複数単元の習熟度の
/// 全体的な停滞が解消し、連続して停滞なしと判定され続けているかを
/// 判定する純関数。`MasteryAcrossUnitsStagnationDetector`自体は2時点の
/// スナップショット比較のみを見る単発判定であり、解消の確認自体は
/// 見ない。`MasteryAcrossUnitsStagnationRecurrenceDetector`は停滞が
/// 繰り返されているかを見るもので、本クラスはその逆軸（解消の確認）を
/// 見る。実際の学習内容の見直し提案・通知の解除方法はアプリ側の責務
/// とする。
class MasteryAcrossUnitsStagnationRecoveryDetector {
  const MasteryAcrossUnitsStagnationRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonStagnationCount) {
    return consecutiveNonStagnationCount >= recoveryThreshold;
  }
}
