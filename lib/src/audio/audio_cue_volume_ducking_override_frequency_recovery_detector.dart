/// `AudioCueVolumeDuckingOverrideFrequencyDetector`が検知した推奨ダッキ
/// ング音量への頻発な手動上書きが解消し、連続して上書きなしと判定され
/// 続けているかを判定する純関数。
/// `AudioCueVolumeDuckingOverrideFrequencyDetector`自体は1回の直近履歴
/// ウィンドウのみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 設定見直し提案の表示の解除方法の見直しはアプリ側の責務とする。
class AudioCueVolumeDuckingOverrideFrequencyRecoveryDetector {
  const AudioCueVolumeDuckingOverrideFrequencyRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonOverriddenCount) {
    return consecutiveNonOverriddenCount >= recoveryThreshold;
  }
}
