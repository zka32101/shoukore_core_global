/// 学習セッション完了時に「やった感」を味わえるフィードバック
/// （達成演出・称賛メッセージ等）を出すべきタイミングかどうかを
/// 判定する純関数。セッション内で一定数以上の問題に取り組んだ
/// 場合にのみ、達成感に見合うフィードバックを出す場面向け。実際の
/// 演出・メッセージ表示自体はアプリ側の責務とする。
class AccomplishmentFeedbackEligibilityDetector {
  const AccomplishmentFeedbackEligibilityDetector({
    this.minAnsweredCount = 3,
  }) : assert(minAnsweredCount > 0);

  /// フィードバック対象とみなす、セッション内の最低解答数。
  final int minAnsweredCount;

  /// [answeredCount]（セッション内で解答した問題数）が
  /// [minAnsweredCount]以上であれば、達成フィードバックの対象と
  /// 判定する。
  bool isEligible(int answeredCount) {
    return answeredCount >= minAnsweredCount;
  }
}
