/// `MultiDeviceConcurrentEditDetector`が検知した複数デバイスからの
/// 同時編集の可能性が解消し、連続してなしと判定され続けているかを
/// 判定する純関数。`MultiDeviceConcurrentEditDetector`自体は1組の
/// 更新ペアについての単発判定であり、解消の確認自体は見ない。
/// `MultiDeviceConcurrentEditRecurrenceDetector`は同時編集の可能性が
/// 繰り返されているかを見るもので、本クラスはその逆軸（解消の確認）
/// を見る。実際の競合解決・保護者への通知の解除方法の見直しはアプリ
/// 側の責務とする。
class MultiDeviceConcurrentEditRecoveryDetector {
  const MultiDeviceConcurrentEditRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonConcurrentEditCount) {
    return consecutiveNonConcurrentEditCount >= recoveryThreshold;
  }
}
