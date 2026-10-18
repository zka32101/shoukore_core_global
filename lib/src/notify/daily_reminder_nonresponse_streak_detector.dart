/// `DailyReminderPlanner`が計算するリマインド通知を送った後、ミッションが
/// 未達成のまま連続して終わっている日数を検知する純関数。
/// `StreakRiskAlert`（当日中にまだ学習していない、残り時間が少ない状態の
/// 単日アラート）とは異なり、本クラスは複数日にわたってリマインド後も
/// 反応がない連続回数のみを見る。実際の通知方法の見直し提案はアプリ側の
/// 責務とする。
class DailyReminderNonresponseStreakDetector {
  const DailyReminderNonresponseStreakDetector({this.streakThreshold = 3});

  /// リマインド後も未達成だった日が連続してこの回数以上であれば、
  /// 疑わしい（通知が効いていない）とみなす。
  final int streakThreshold;

  /// [wasMissionCompletedNewestFirst]（直近の日から新しい順の、リマインド
  /// 送信後にミッションが達成されたかのフラグ列）の先頭から数えて、
  /// 連続して未達成（`false`）だった日数が[streakThreshold]以上であれば、
  /// 連続未達成とみなす。
  bool isNonresponseStreak(List<bool> wasMissionCompletedNewestFirst) {
    var consecutiveNonresponses = 0;
    for (final wasCompleted in wasMissionCompletedNewestFirst) {
      if (wasCompleted) break;
      consecutiveNonresponses++;
    }
    return consecutiveNonresponses >= streakThreshold;
  }
}
