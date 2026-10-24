/// `AnswerAccuracyDeclineTrendDetector`が検知した正答率の悪化傾向が解消
/// し、連続して正答率が安定していると判定され続けているかを判定する
/// 純関数。`AnswerAccuracyDeclineTrendDetector`自体は1回の直近履歴
/// ウィンドウのみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 難易度調整・復習案の表示の解除方法の見直しはアプリ側の責務とする。
class AnswerAccuracyDeclineTrendRecoveryDetector {
  const AnswerAccuracyDeclineTrendRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonDecliningCount) {
    return consecutiveNonDecliningCount >= recoveryThreshold;
  }
}
