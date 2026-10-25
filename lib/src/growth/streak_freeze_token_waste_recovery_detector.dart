/// `StreakFreezeTokenWasteDetector`が検知したストリークフリーズ
/// トークンの無駄遣い状態が解消し、連続してトークンが活用されるよう
/// になったと判定され続けているかを判定する純関数。
/// `StreakFreezeTokenWasteDetector`自体は無駄遣い状態の有無のみを見る
/// 単発判定であり、解消の確認自体は見ない。実際の「トークンを早めに
/// 使おう」案内の解除方法の見直しはアプリ側の責務とする。
class StreakFreezeTokenWasteRecoveryDetector {
  const StreakFreezeTokenWasteRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveUsedCount]（直近から連続してトークンが使用された
  /// 回数）が[recoveryThreshold]以上であれば、解消状態と判定する。
  bool isRecovered(int consecutiveUsedCount) {
    return consecutiveUsedCount >= recoveryThreshold;
  }
}
