/// `ProfileAvatarRotationSuggestionIgnoredDetector`が検知したアバター
/// 変更提案の連続無視状態が解消し、連続して提案が受け入れられるように
/// なったと判定され続けているかを判定する純関数。
/// `ProfileAvatarRotationSuggestionIgnoredDetector`自体は連続無視の
/// 有無のみを見る単発判定であり、解消の確認自体は見ない。実際の提案
/// 方法の見直し・表示頻度の調整はアプリ側の責務とする。
class ProfileAvatarRotationSuggestionIgnoredRecoveryDetector {
  const ProfileAvatarRotationSuggestionIgnoredRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveAcceptedCount]（直近から連続して受け入れられた提案の
  /// 回数）が[recoveryThreshold]以上であれば、解消状態と判定する。
  bool isRecovered(int consecutiveAcceptedCount) {
    return consecutiveAcceptedCount >= recoveryThreshold;
  }
}
