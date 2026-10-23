/// `ProfileSwitchRevertDetector`が検知した誤操作らしきプロフィール切替
/// が解消し、連続してなしと判定され続けているかを判定する純関数。
/// `ProfileSwitchRevertDetector`自体は1回の切替操作のみを見る単発判定
/// であり、解消の確認自体は見ない。実際の「間違えましたか？」案内の
/// 解除方法の見直しはアプリ側の責務とする。
class ProfileSwitchRevertRecoveryDetector {
  const ProfileSwitchRevertRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonAccidentalSwitchCount) {
    return consecutiveNonAccidentalSwitchCount >= recoveryThreshold;
  }
}
