/// `AudioCueVolumeDuckingOverrideStreakDetector`が検知した推奨ダッキング
/// 音量の連続上書き状態が解消し、連続して上書きされなくなったと判定
/// され続けているかを判定する純関数。
/// `AudioCueVolumeDuckingOverrideStreakDetector`自体は連続上書きの
/// 有無のみを見る単発判定であり、解消の確認自体は見ない。実際の設定
/// 見直し提案の解除方法はアプリ側の責務とする。
class AudioCueVolumeDuckingOverrideStreakRecoveryDetector {
  const AudioCueVolumeDuckingOverrideStreakRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveNonOverrideCount]（直近から連続して上書きされなかった
  /// 回数）が[recoveryThreshold]以上であれば、解消状態と判定する。
  bool isRecovered(int consecutiveNonOverrideCount) {
    return consecutiveNonOverrideCount >= recoveryThreshold;
  }
}
