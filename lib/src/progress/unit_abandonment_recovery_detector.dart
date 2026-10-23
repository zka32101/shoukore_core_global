/// `UnitAbandonmentDetector`が検知した単元の放置状態が解消し、連続して
/// 放置なしと判定され続けているかを判定する純関数。
/// `UnitAbandonmentDetector`自体は直近の学習日時との1回分の比較のみを
/// 見る単発判定であり、解消の確認自体は見ない。
/// `UnitAbandonmentRecurrenceDetector`は放置が繰り返されているかを見る
/// もので、本クラスはその逆軸（解消の確認）を見る。実際の「もう一度
/// やってみよう」案内の解除方法の見直しはアプリ側の責務とする。
class UnitAbandonmentRecoveryDetector {
  const UnitAbandonmentRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonAbandonmentCount) {
    return consecutiveNonAbandonmentCount >= recoveryThreshold;
  }
}
