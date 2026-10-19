/// `ProfileAvatarRotationSuggester`が提案したアバター変更が連続して無視
/// され続けている状態を検知する純関数。`ProfileAvatarChangeFrequencyThrottle`
/// は変更が多すぎる場合を抑制する逆方向の軸であり、提案が無視されている
/// かどうかは見ない。`ProfileAvatarRotationSuggester`自体は提案すべきか
/// どうかの判定のみを行い、提案後の反応は見ない。実際の提案方法の見直し・
/// 表示頻度の調整はアプリ側の責務とする。
class ProfileAvatarRotationSuggestionIgnoredDetector {
  const ProfileAvatarRotationSuggestionIgnoredDetector({
    this.ignoredThreshold = 3,
  });

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int ignoredThreshold;

  /// [consecutiveIgnoredCount]（直近から連続して無視された提案の回数）
  /// が[ignoredThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyIgnored(int consecutiveIgnoredCount) {
    return consecutiveIgnoredCount >= ignoredThreshold;
  }
}
