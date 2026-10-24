/// `QuestionVarietyBiasDetector`が検知した出題タグの偏りが解消し、
/// 連続して多様性が戻っていると判定され続けているかを判定する純関数。
/// `QuestionVarietyBiasDetector`自体は1回の直近履歴ウィンドウのみを見る
/// 単発判定であり、解消の確認自体は見ない。実際の出題選定ロジックの
/// 見直しはアプリ側の責務とする。
class QuestionVarietyBiasRecoveryDetector {
  const QuestionVarietyBiasRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonBiasedCount) {
    return consecutiveNonBiasedCount >= recoveryThreshold;
  }
}
