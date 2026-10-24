/// `DeviceLocaleSuggestionIgnoredDetector`が連続無視と判定する閾値に
/// まだ到達していないが、あと少しで到達しそうな状態を検知する純関数。
/// `DeviceLocaleSuggestionIgnoredDetector`自体は閾値到達後のみを判定
/// し、到達前の接近状態自体は見ない。実際の早期の提案方法見直しは
/// アプリ側の責務とする。
class DeviceLocaleSuggestionIgnoredApproachingDetector {
  const DeviceLocaleSuggestionIgnoredApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveIgnoredCount]（直近から連続して、提案と異なるロケールが
  /// 選ばれた回数）が[ignoredThreshold]未満かつ、
  /// [ignoredThreshold] * (1 - [marginRatio])以上であれば、接近状態と
  /// 判定する。
  bool isApproaching({
    required int consecutiveIgnoredCount,
    required int ignoredThreshold,
  }) {
    if (consecutiveIgnoredCount >= ignoredThreshold) {
      return false;
    }
    final marginStart = (ignoredThreshold * (1 - marginRatio)).ceil();
    return consecutiveIgnoredCount >= marginStart;
  }
}
