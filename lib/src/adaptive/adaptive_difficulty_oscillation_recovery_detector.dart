/// `AdaptiveDifficultyOscillationDetector`が検知した難易度の振動状態が
/// 解消し、連続して安定していると判定され続けているかを判定する純関数。
/// `AdaptiveDifficultyOscillationDetector`自体は1回の直近履歴ウィンドウ
/// のみを見る単発判定であり、解消の確認自体は見ない。実際の難易度調整
/// ロジックの見直し・単元切り替え提案の解除方法の見直しはアプリ側の
/// 責務とする。
class AdaptiveDifficultyOscillationRecoveryDetector {
  const AdaptiveDifficultyOscillationRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonOscillatingCount) {
    return consecutiveNonOscillatingCount >= recoveryThreshold;
  }
}
