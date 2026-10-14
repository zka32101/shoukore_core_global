import 'daily_boundary.dart';

/// デイリーミッションのその日の進捗。immutableで、状態遷移は[DailyMissionRules]が行う。
class DailyMissionState {
  const DailyMissionState({
    required this.missionDay,
    this.completedCount = 0,
    this.rewardClaimed = false,
  });

  final DateTime missionDay;
  final int completedCount;
  final bool rewardClaimed;
}

/// デイリーミッションの目標件数・報酬ルール。固定5:00リセットは廃止し、
/// 日付境界は[DailyBoundary]（profile駆動）に委ねる。閾値は差し替え可能。
class DailyMissionRules {
  const DailyMissionRules({this.targetCount = 5, this.rewardCoins = 10});

  final int targetCount;
  final int rewardCoins;

  /// 問題を1問解いた直後の状態遷移。日付境界をまたいでいれば新しいミッション日として初期化する。
  DailyMissionState recordCompletion({
    required DailyMissionState? previous,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    final today = boundary.missionDayOf(now);
    final base = (previous == null || previous.missionDay != today)
        ? DailyMissionState(missionDay: today)
        : previous;
    return DailyMissionState(
      missionDay: today,
      completedCount: base.completedCount + 1,
      rewardClaimed: base.rewardClaimed,
    );
  }

  bool isRewardEligible(DailyMissionState state) =>
      state.completedCount >= targetCount && !state.rewardClaimed;

  DailyMissionState claimReward(DailyMissionState state) => DailyMissionState(
        missionDay: state.missionDay,
        completedCount: state.completedCount,
        rewardClaimed: true,
      );
}
