/// `ConsentAuditLogGapDetector`が検知した同意履歴の記録空白が解消し、
/// 連続して記録が続いている状態と判定され続けているかを判定する純
/// 関数。`ConsentAuditLogGapDetector`自体は直近のイベントとの1回分の
/// 比較のみを見る単発判定であり、解消の確認自体は見ない。
/// `ConsentAuditLogGapRecurrenceDetector`は空白が繰り返されているかを
/// 見るもので、本クラスはその逆軸（解消の確認）を見る。実際の同意状態
/// 再確認案内の解除方法の見直しはアプリ側の責務とする。
class ConsentAuditLogGapRecoveryDetector {
  const ConsentAuditLogGapRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonGapCount) {
    return consecutiveNonGapCount >= recoveryThreshold;
  }
}
