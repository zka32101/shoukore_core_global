/// `CoinSpendingLimitHabitualMaxOutDetector`が検知した日次コイン消費上限
/// への連日到達の常態化が解消し、連続して上限未到達と判定され続けている
/// かを判定する純関数。`CoinSpendingLimitHabitualMaxOutDetector`自体は
/// 1回の直近履歴ウィンドウのみを見る単発判定であり、解消の確認自体は
/// 見ない。実際の上限緩和提案・使い道の見直し案内の解除方法の見直しは
/// アプリ側の責務とする。
class CoinSpendingLimitHabitualMaxOutRecoveryDetector {
  const CoinSpendingLimitHabitualMaxOutRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonHabitualCount) {
    return consecutiveNonHabitualCount >= recoveryThreshold;
  }
}
