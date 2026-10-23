/// `TimeZoneDriftDetector`が検知したタイムゾーンの変化が収まり、連続
/// して変化なしと判定され続けているかを判定する純関数。
/// `TimeZoneDriftDetector`自体は前回記録との1回分の比較のみを見る単発
/// 判定であり、収まったことの確認自体は見ない。
/// `TimeZoneDriftRecurrenceDetector`は変化が繰り返されているかを見る
/// もので、本クラスはその逆軸（収まったことの確認）を見る。実際の再
/// 確認ダイアログの解除方法の見直しはアプリ側の責務とする。
class TimeZoneDriftRecoveryDetector {
  const TimeZoneDriftRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonDriftCount) {
    return consecutiveNonDriftCount >= recoveryThreshold;
  }
}
