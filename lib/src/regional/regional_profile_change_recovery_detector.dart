/// `RegionalProfileChangeDetector`が検知した地域プロフィールの変化が
/// 収まり、連続して変化なしと判定され続けているかを判定する純関数。
/// `RegionalProfileChangeDetector`自体はキャッシュと最新値との1回分の
/// 比較のみを見る単発判定であり、収まったことの確認自体は見ない。
/// `RegionalProfileChangeRecurrenceDetector`は変化が繰り返されている
/// かを見るもので、本クラスはその逆軸（収まったことの確認）を見る。
/// 実際の再確認案内の解除方法の見直しはアプリ側の責務とする。
class RegionalProfileChangeRecoveryDetector {
  const RegionalProfileChangeRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonChangeCount) {
    return consecutiveNonChangeCount >= recoveryThreshold;
  }
}
