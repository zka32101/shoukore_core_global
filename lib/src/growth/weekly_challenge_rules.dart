/// 週単位でリセットされる短期目標(「今週あとN問正解で達成」)の記録状態。
/// `weekStart`(週の開始日、月曜0時・日付のみ)と、その週に達成した件数を
/// 保持する。
class WeeklyChallengeState {
  const WeeklyChallengeState({this.weekStart, this.completedCount = 0});

  /// 未保存・初回起動時の既定状態。
  static const initial = WeeklyChallengeState();

  /// 今週の開始日(月曜、日付のみ)。未保存ならnull。
  final DateTime? weekStart;
  final int completedCount;
}

/// デイリーミッション(`DailyMissionRules`)・デイリーボーナスコイン
/// (`DailyCoinEarningRules`)と同じ「期間境界で自動リセットされるカウンター」
/// パターンを、週単位に適用したもの。教科・国に依存しない純粋ロジックで、
/// 週の始まりの定義(月曜始まり)・目標件数(`totalTarget`)のみを持つ。
class WeeklyChallengeRules {
  const WeeklyChallengeRules({this.totalTarget = 15});

  final int totalTarget;

  /// [at]が属する週の開始日(月曜、日付のみ)を返す。
  DateTime weekStartOf(DateTime at) {
    final dateOnly = DateTime(at.year, at.month, at.day);
    // DateTime.weekday: 月曜=1 ... 日曜=7。今週の月曜まで戻る。
    return dateOnly.subtract(Duration(days: dateOnly.weekday - 1));
  }

  /// [stored]が今週のものであればそのまま、週をまたいでいれば0件から
  /// 数え直した状態を返す(保存前の表示用に使う、副作用のない読み取り)。
  WeeklyChallengeState currentState({
    required WeeklyChallengeState stored,
    required DateTime now,
  }) {
    final currentWeekStart = weekStartOf(now);
    if (stored.weekStart == currentWeekStart) return stored;
    return WeeklyChallengeState(weekStart: currentWeekStart, completedCount: 0);
  }

  /// 正解1件を記録する。週をまたいでいれば0件から数え直し、
  /// [totalTarget]に達していればそれ以上増やさない。
  WeeklyChallengeState recordCorrectAnswer({
    required WeeklyChallengeState previous,
    required DateTime now,
  }) {
    final base = currentState(stored: previous, now: now);
    if (base.completedCount >= totalTarget) return base;
    return WeeklyChallengeState(
      weekStart: base.weekStart,
      completedCount: base.completedCount + 1,
    );
  }
}
