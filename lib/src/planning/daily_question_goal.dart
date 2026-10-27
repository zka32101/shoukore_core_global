/// 「毎日何問やる」という日次の出題数目標と、その日の実施数から
/// 達成判定を行う純関数。実際の目標数の設定UI・達成演出自体は
/// アプリ側の責務とする。
class DailyQuestionGoal {
  const DailyQuestionGoal({this.targetCount = 10}) : assert(targetCount > 0);

  /// 1日に解くべき目標問題数。
  final int targetCount;

  /// [answeredCount]（その日に解いた問題数）が[targetCount]以上で
  /// あれば達成と判定する。
  bool isAchieved(int answeredCount) {
    return answeredCount >= targetCount;
  }

  /// 目標達成まで残り何問かを返す。達成済みであれば0を返す。
  int remainingToGoal(int answeredCount) {
    final remaining = targetCount - answeredCount;
    return remaining > 0 ? remaining : 0;
  }
}
