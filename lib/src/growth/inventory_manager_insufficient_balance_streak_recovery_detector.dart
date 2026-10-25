/// `InventoryManagerInsufficientBalanceStreakDetector`が検知した残高
/// 不足による連続購入失敗状態が解消し、連続して購入できるようになった
/// と判定され続けているかを判定する純関数。
/// `InventoryManagerInsufficientBalanceStreakDetector`自体は連続残高
/// 不足の有無のみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 「コインを増やす方法」案内の解除方法はアプリ側の責務とする。
class InventoryManagerInsufficientBalanceStreakRecoveryDetector {
  const InventoryManagerInsufficientBalanceStreakRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveSufficientCount]（直近から連続して残高が足りて購入
  /// できた回数）が[recoveryThreshold]以上であれば、解消状態と判定
  /// する。
  bool isRecovered(int consecutiveSufficientCount) {
    return consecutiveSufficientCount >= recoveryThreshold;
  }
}
