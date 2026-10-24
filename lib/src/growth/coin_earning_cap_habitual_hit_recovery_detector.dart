/// `CoinEarningCapHabitualHitDetector`が検知した日次コイン獲得上限への
/// 連日到達の常態化が解消し、連続して上限未到達と判定され続けている
/// かを判定する純関数。`CoinEarningCapHabitualHitDetector`自体は1回の
/// 直近履歴ウィンドウのみを見る単発判定であり、解消の確認自体は見ない。
/// 実際の上限緩和提案・追加の獲得手段の案内の解除方法の見直しはアプリ
/// 側の責務とする。
class CoinEarningCapHabitualHitRecoveryDetector {
  const CoinEarningCapHabitualHitRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonHabitualCount) {
    return consecutiveNonHabitualCount >= recoveryThreshold;
  }
}
