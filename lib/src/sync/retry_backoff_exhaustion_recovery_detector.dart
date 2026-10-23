/// `RetryBackoffExhaustionRateAlert`がシステム的な同期障害と判定した
/// 状態が解消し、連続してなしと判定され続けているかを判定する純関数。
/// `RetryBackoffExhaustionRateAlert`自体は1回の判定時点での枯渇件数の
/// 割合のみを見る単発判定であり、解消の確認自体は見ない。
/// `RetryBackoffExhaustionRecurrenceDetector`は障害判定が繰り返されて
/// いるかを見るもので、本クラスはその逆軸（解消の確認）を見る。実際の
/// サーバー状態の確認・メンテナンス通知の解除方法の見直しはアプリ側
/// の責務とする。
class RetryBackoffExhaustionRecoveryDetector {
  const RetryBackoffExhaustionRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonSystemicFailureCount) {
    return consecutiveNonSystemicFailureCount >= recoveryThreshold;
  }
}
