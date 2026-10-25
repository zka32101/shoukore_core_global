/// `GuardianApprovalRequestRepeatedRejectionStreakDetector`が検知した
/// 保護者承認申請の連続却下状態が解消し、連続して承認されるように
/// なったと判定され続けているかを判定する純関数。
/// `GuardianApprovalRequestRepeatedRejectionStreakDetector`自体は連続
/// 却下の有無のみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 再申請制限・案内表示の解除方法はアプリ側の責務とする。
class GuardianApprovalRequestRepeatedRejectionStreakRecoveryDetector {
  const GuardianApprovalRequestRepeatedRejectionStreakRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveApprovedCount]（直近から連続して承認された申請の
  /// 回数）が[recoveryThreshold]以上であれば、解消状態と判定する。
  bool isRecovered(int consecutiveApprovedCount) {
    return consecutiveApprovedCount >= recoveryThreshold;
  }
}
