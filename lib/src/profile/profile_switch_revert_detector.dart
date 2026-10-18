/// プロフィールを切り替えた直後に、すぐ元のプロフィールへ戻す操作が
/// 行われた場合、誤操作による切替だった可能性を検知する純関数。
/// `ProfileSwitchCooldown`は切替操作自体の連続頻度を制限するだけで、
/// 戻す操作のパターンは見ないため、本クラスが独立してその判定を行う。
/// 実際の「間違えましたか？」案内の表示はアプリ側の責務とする。
class ProfileSwitchRevertDetector {
  const ProfileSwitchRevertDetector({this.revertWindow = const Duration(seconds: 10)});

  /// 切替からこの時間以内に元のプロフィールへ戻せば誤操作とみなす。
  final Duration revertWindow;

  /// [previousProfileId]（切替前のプロフィールID）と[revertedToProfileId]
  /// （戻し先のプロフィールID）が一致し、かつ[switchedAt]（切替実行時刻）
  /// から[revertedAt]（戻す操作の時刻）までの経過が[revertWindow]以内で
  /// あれば、誤操作による切替と判定する。
  bool isAccidentalSwitch({
    required String previousProfileId,
    required String revertedToProfileId,
    required DateTime switchedAt,
    required DateTime revertedAt,
  }) {
    if (previousProfileId != revertedToProfileId) return false;
    return revertedAt.difference(switchedAt) <= revertWindow;
  }
}
