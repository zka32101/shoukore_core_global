/// 1回の学習セッション内で、連続解答数・経過時間から「そろそろ休憩を
/// 提案すべきか」を判定する純関数。`SessionTimeoutPolicy`（無操作による
/// 強制ロック）とは独立しており、あくまで推奨休憩タイミングを計算するだけ。
/// 実際の休憩提案UI・タイマー管理はアプリ側の責務とする。
class ReviewSessionPacer {
  const ReviewSessionPacer({
    this.answerCountThreshold = 20,
    this.elapsedThreshold = const Duration(minutes: 15),
  }) : assert(answerCountThreshold > 0);

  /// 休憩を提案するまでの連続解答数の閾値。
  final int answerCountThreshold;

  /// 休憩を提案するまでの経過時間の閾値。
  final Duration elapsedThreshold;

  /// セッション開始からの[answeredCount]件数または[elapsed]経過時間の
  /// いずれかが閾値を超えていれば、休憩を提案すべきと判定する。
  bool shouldSuggestBreak({
    required int answeredCount,
    required Duration elapsed,
  }) {
    return answeredCount >= answerCountThreshold || elapsed >= elapsedThreshold;
  }
}
