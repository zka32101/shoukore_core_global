/// 連続正解数（回答1回ごとの連続正解、`LearningStreak`の学習日連続とは別物）
/// に応じたボーナスコインを計算する純関数。何正解ごとに何コイン追加するかを
/// `interval`/`bonusPerInterval`で指定するだけで、実際の`CoinWallet.earn`
/// への反映はアプリ側が行う。
class AnswerStreakBonus {
  const AnswerStreakBonus({
    this.interval = 5,
    this.bonusPerInterval = 10,
  })  : assert(interval > 0),
        assert(bonusPerInterval >= 0);

  /// この回数の連続正解ごとにボーナスを付与する。
  final int interval;

  /// [interval]回ごとに付与するボーナスコイン数。
  final int bonusPerInterval;

  /// [consecutiveCorrectCount]（直近の回答までの連続正解数）が[interval]の
  /// 倍数に達した時点でのみボーナスを返す。達していない場合は0。
  int bonusFor(int consecutiveCorrectCount) {
    if (consecutiveCorrectCount <= 0) return 0;
    if (consecutiveCorrectCount % interval != 0) return 0;
    return bonusPerInterval;
  }
}
