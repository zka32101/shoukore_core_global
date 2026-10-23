/// `GuardianGateRapidAttemptDetector`が検知した保護者ゲートへの異常に
/// 速い連続試行が収まり、連続して正常な試行間隔と判定され続けている
/// かを判定する純関数。`GuardianGateRapidAttemptDetector`自体は直前
/// 1回分の試行間隔のみを見る単発判定であり、収まったことの確認自体は
/// 見ない。`GuardianGateRapidAttemptRecurrenceDetector`は異常な連続
/// 試行が繰り返されているかを見るもので、本クラスはその逆軸（収まった
/// ことの確認）を見る。実際の追加ロックの解除方法の見直しはアプリ側の
/// 責務とする。
class GuardianGateRapidAttemptRecoveryDetector {
  const GuardianGateRapidAttemptRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonSuspiciousCount) {
    return consecutiveNonSuspiciousCount >= recoveryThreshold;
  }
}
