/// `EntitlementGracePeriodRepeatedUsageDetector`が検知した猶予期間の
/// 繰り返し利用パターンが解消し、連続して猶予期間に入らず更新される
/// ようになったと判定され続けているかを判定する純関数。
/// `EntitlementGracePeriodRepeatedUsageDetector`自体は繰り返しパターン
/// の有無のみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 更新方法の見直し案内の解除方法はアプリ側の責務とする。
class EntitlementGracePeriodRepeatedUsageRecoveryDetector {
  const EntitlementGracePeriodRepeatedUsageRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveNonGracePeriodUsageCount]（直近から連続して猶予期間に
  /// 入らず更新された課金サイクルの回数）が[recoveryThreshold]以上で
  /// あれば、解消状態と判定する。
  bool isRecovered(int consecutiveNonGracePeriodUsageCount) {
    return consecutiveNonGracePeriodUsageCount >= recoveryThreshold;
  }
}
