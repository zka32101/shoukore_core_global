import 'daily_boundary.dart';

/// 学習ストリーク（何日連続で学習したか）の状態。immutableで、
/// 状態遷移は[LearningStreak.recordStudy]が行う純関数。
class LearningStreak {
  const LearningStreak({this.currentStreakDays = 0, this.lastStudiedDay});

  final int currentStreakDays;

  /// 直近に学習イベントがあったミッション日。未学習なら`null`。
  final DateTime? lastStudiedDay;

  /// [now]に学習イベント（出題への回答、正誤は問わない）が発生した際の
  /// 次のストリーク状態を返す。同じミッション日内の2回目以降の学習は
  /// ストリークを増やさない。前回の学習日の翌ミッション日なら+1、
  /// それ以外（間隔が空いた、または初回）なら1にリセットする。
  LearningStreak recordStudy({required DateTime now, required DailyBoundary boundary}) {
    final today = boundary.missionDayOf(now);
    final lastDay = lastStudiedDay;
    if (lastDay != null && boundary.isSameMissionDay(lastDay, today)) {
      return this;
    }
    final isConsecutive =
        lastDay != null && boundary.missionDayOf(lastDay.add(const Duration(days: 1))) == today;
    return LearningStreak(
      currentStreakDays: isConsecutive ? currentStreakDays + 1 : 1,
      lastStudiedDay: today,
    );
  }
}
