/// `MasteryRapidDecayDetector`が検知した習熟度の急激な減衰が収まり、
/// 連続して急激な減衰なしと判定され続けているかを判定する純関数。
/// `MasteryRapidDecayDetector`自体は直近1回分の減衰量のみを見る単発
/// 判定であり、収まったことの確認自体は見ない。
/// `MasteryRapidDecayRecurrenceDetector`は急激な減衰が繰り返されている
/// かを見るもので、本クラスはその逆軸（収まったことの確認）を見る。
/// 実際の優先表示・通知の解除方法の見直しはアプリ側の責務とする。
class MasteryRapidDecayRecoveryDetector {
  const MasteryRapidDecayRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonRapidDecayCount) {
    return consecutiveNonRapidDecayCount >= recoveryThreshold;
  }
}
