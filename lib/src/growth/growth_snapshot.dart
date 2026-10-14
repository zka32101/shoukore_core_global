/// `GrowthStore`が読み書きする永続化スナップショット。
/// `CoinWallet`/`DailyMissionState`/累計正答数（`GrowthStageCalculator`の入力）を
/// まとめて1つの状態として保存・復元する。
class GrowthSnapshot {
  const GrowthSnapshot({
    this.totalCorrectAnswers = 0,
    this.coinBalance = 0,
    this.missionDay,
    this.missionCompletedCount = 0,
    this.missionRewardClaimed = false,
    this.currentStreakDays = 0,
    this.lastStudiedDay,
  });

  /// 未保存・初回起動時の既定状態。
  static const initial = GrowthSnapshot();

  final int totalCorrectAnswers;
  final int coinBalance;

  /// 直近保存されたデイリーミッションの日付。`null`ならミッション未開始。
  final DateTime? missionDay;
  final int missionCompletedCount;
  final bool missionRewardClaimed;

  /// 現在の学習ストリーク（何日連続で学習したか）。`LearningStreak`の状態。
  final int currentStreakDays;
  final DateTime? lastStudiedDay;
}
