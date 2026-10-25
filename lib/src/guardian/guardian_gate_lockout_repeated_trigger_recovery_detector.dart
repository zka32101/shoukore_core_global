/// `GuardianGateLockoutRepeatedTriggerDetector`が検知した繰り返し
/// ロックアウト発生が解消し、連続してロックアウトが発生しなくなったと
/// 判定され続けているかを判定する純関数。
/// `GuardianGateLockoutRepeatedTriggerDetector`自体は繰り返し発生の
/// 有無のみを見る単発判定であり、解消の確認自体は見ない。実際の警戒
/// 表示の解除方法の見直しはアプリ側の責務とする。
class GuardianGateLockoutRepeatedTriggerRecoveryDetector {
  const GuardianGateLockoutRepeatedTriggerRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveNonLockoutCount]（直近から連続してロックアウトが
  /// 発生しなかった回数）が[recoveryThreshold]以上であれば、解消状態
  /// と判定する。
  bool isRecovered(int consecutiveNonLockoutCount) {
    return consecutiveNonLockoutCount >= recoveryThreshold;
  }
}
