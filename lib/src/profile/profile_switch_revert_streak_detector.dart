/// `ProfileSwitchRevertDetector`が誤操作と判定したプロフィール切替が
/// 連続して繰り返されている状態を検知する純関数。
/// `ProfileSwitchRevertDetector`自体は単発の切替・戻し操作の組が誤操作
/// だったかのみを判定し、連続して繰り返されているかは見ない。実際の
/// 「切替方法を見直しますか？」案内の表示はアプリ側の責務とする。
class ProfileSwitchRevertStreakDetector {
  const ProfileSwitchRevertStreakDetector({this.streakThreshold = 3})
      : assert(streakThreshold > 0);

  /// 連続した誤操作がこの回数以上になったら検知対象とみなす。
  final int streakThreshold;

  /// [consecutiveAccidentalSwitchCount]（直近から連続して誤操作と判定
  /// された切替の回数）が[streakThreshold]以上であれば、連続発生と
  /// 判定する。
  bool isRecurring(int consecutiveAccidentalSwitchCount) {
    return consecutiveAccidentalSwitchCount >= streakThreshold;
  }
}
