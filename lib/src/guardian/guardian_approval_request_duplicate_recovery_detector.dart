/// `GuardianApprovalRequestDuplicateDetector`が検知した承認待ち申請の
/// 重複が解消し、連続して重複なしと判定され続けているかを判定する純
/// 関数。`GuardianApprovalRequestDuplicateDetector`自体は1件の候補に
/// ついての単発判定であり、解消の確認自体は見ない。
/// `GuardianApprovalRequestDuplicateRecurrenceDetector`は重複が繰り
/// 返されているかを見るもので、本クラスはその逆軸（解消の確認）を
/// 見る。実際の重複申請の統合・再送抑制の解除方法の見直しはアプリ側
/// の責務とする。
class GuardianApprovalRequestDuplicateRecoveryDetector {
  const GuardianApprovalRequestDuplicateRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonDuplicateCount) {
    return consecutiveNonDuplicateCount >= recoveryThreshold;
  }
}
