/// `AudioMuteToggleFrequencyDetector`が検知したミュート/解除の頻発な
/// 切り替えが解消し、連続して頻発なしと判定され続けているかを判定する
/// 純関数。`AudioMuteToggleFrequencyDetector`自体は1回の観測ウィンドウ
/// のみを見る単発判定であり、解消の確認自体は見ない。実際の設定UIの
/// 見直し案内の解除方法の見直しはアプリ側の責務とする。
class AudioMuteToggleFrequencyRecoveryDetector {
  const AudioMuteToggleFrequencyRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonFrequentCount) {
    return consecutiveNonFrequentCount >= recoveryThreshold;
  }
}
