/// `AnswerLatencyVarianceSpikeDetector`が検知した解答時間のバラつきの
/// 急増が解消し、連続して安定していると判定され続けているかを判定する
/// 純関数。`AnswerLatencyVarianceSpikeDetector`自体は1ウィンドウ分の
/// 解答時間列のみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 集中力低下への対応・通知の解除方法の見直しはアプリ側の責務とする。
class AnswerLatencyVarianceSpikeRecoveryDetector {
  const AnswerLatencyVarianceSpikeRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonSpikeCount) {
    return consecutiveNonSpikeCount >= recoveryThreshold;
  }
}
