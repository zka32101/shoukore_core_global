/// `AdaptiveDifficultyPlateauDetector`が検知した難易度の停滞が解消し、
/// 連続して難易度が変化していると判定され続けているかを判定する純関数。
/// `AdaptiveDifficultyPlateauDetector`自体は1回の直近履歴ウィンドウの
/// みを見る単発判定であり、解消の確認自体は見ない。実際の単元切り替え
/// 提案・休憩提案の解除方法の見直しはアプリ側の責務とする。
class AdaptiveDifficultyPlateauRecoveryDetector {
  const AdaptiveDifficultyPlateauRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonPlateauCount) {
    return consecutiveNonPlateauCount >= recoveryThreshold;
  }
}
