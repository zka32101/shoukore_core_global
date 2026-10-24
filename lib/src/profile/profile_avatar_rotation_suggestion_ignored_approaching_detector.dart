/// `ProfileAvatarRotationSuggestionIgnoredDetector`が連続無視と判定
/// する閾値にまだ到達していないが、あと少しで到達しそうな状態を検知
/// する純関数。`ProfileAvatarRotationSuggestionIgnoredDetector`自体
/// は閾値到達後のみを判定し、到達前の接近状態自体は見ない。実際の
/// 早期の提案方法見直し・表示頻度の調整はアプリ側の責務とする。
class ProfileAvatarRotationSuggestionIgnoredApproachingDetector {
  const ProfileAvatarRotationSuggestionIgnoredApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveIgnoredCount]（直近から連続して無視された提案の回数）
  /// が[ignoredThreshold]未満かつ、
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
