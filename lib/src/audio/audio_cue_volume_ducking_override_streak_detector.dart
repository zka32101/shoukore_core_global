/// `AudioCueVolumeDuckingSuggestion`が算出した推奨ダッキング音量が、
/// 連続して上書きされ続けている状態を検知する純関数。
/// `AudioCueVolumeDuckingOverrideFrequencyDetector`は直近件数内の上書き
/// 回数（頻度）のみを見るため、連続性（streak）は見ない。実際の設定
/// 見直し提案の表示はアプリ側の責務とする。
class AudioCueVolumeDuckingOverrideStreakDetector {
  const AudioCueVolumeDuckingOverrideStreakDetector({this.overrideStreakThreshold = 3})
      : assert(overrideStreakThreshold > 0);

  /// 連続して上書きされた回数がこの回数以上になったら検知対象とみなす。
  final int overrideStreakThreshold;

  /// [consecutiveOverrideCount]（直近から連続して上書きされた回数）が
  /// [overrideStreakThreshold]以上であれば、連続上書き状態と判定する。
  bool isOverriding(int consecutiveOverrideCount) {
    return consecutiveOverrideCount >= overrideStreakThreshold;
  }
}
