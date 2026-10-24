/// `QuestionRepetitionFatigueDetector`が検知した同一問題の繰り返し出題
/// による疲労状態が解消し、連続して多様な出題と判定され続けているかを
/// 判定する純関数。`QuestionRepetitionFatigueDetector`自体は1回の直近
/// 履歴ウィンドウのみを見る単発判定であり、解消の確認自体は見ない。
/// 実際の出題プールからの除外・差し替えの解除方法の見直しはアプリ側
/// の責務とする。
class QuestionRepetitionFatigueRecoveryDetector {
  const QuestionRepetitionFatigueRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonFatiguedCount) {
    return consecutiveNonFatiguedCount >= recoveryThreshold;
  }
}
