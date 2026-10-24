/// `AudioCueVolumeDuckingOverrideStreakDetector`が連続上書き状態と
/// 判定する閾値にまだ到達していないが、あと少しで到達しそうな状態を
/// 検知する純関数。`AudioCueVolumeDuckingOverrideStreakDetector`自体
/// は閾値到達後のみを判定し、到達前の接近状態自体は見ない。実際の
/// 早期の設定見直し提案の表示はアプリ側の責務とする。
class AudioCueVolumeDuckingOverrideStreakApproachingDetector {
  const AudioCueVolumeDuckingOverrideStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveOverrideCount]（直近から連続して上書きされた回数）が
  /// [overrideStreakThreshold]未満かつ、
  /// [overrideStreakThreshold] * (1 - [marginRatio])以上であれば、
  /// 接近状態と判定する。
  bool isApproaching({
    required int consecutiveOverrideCount,
    required int overrideStreakThreshold,
  }) {
    if (consecutiveOverrideCount >= overrideStreakThreshold) {
      return false;
    }
    final marginStart =
        (overrideStreakThreshold * (1 - marginRatio)).ceil();
    return consecutiveOverrideCount >= marginStart;
  }
}
