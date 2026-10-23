/// `GuardianTimezoneMismatchDetector`が検知した子どもと保護者の端末間の
/// タイムゾーン不一致が解消し、連続して一致と判定され続けているかを
/// 判定する純関数。`GuardianTimezoneMismatchDetector`自体は1回分の
/// オフセット差の比較のみを見る単発判定であり、解消の確認自体は見ない。
/// `GuardianTimezoneMismatchRecurrenceDetector`は不一致が繰り返されて
/// いるかを見るもので、本クラスはその逆軸（解消の確認）を見る。実際の
/// 通知時刻補正の解除方法の見直しはアプリ側の責務とする。
class GuardianTimezoneMismatchRecoveryDetector {
  const GuardianTimezoneMismatchRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonMismatchCount) {
    return consecutiveNonMismatchCount >= recoveryThreshold;
  }
}
