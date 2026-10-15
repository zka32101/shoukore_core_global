/// 保護者向けの1日分の要約データ。文言化（通知文・arb）はアプリ側の責務とし、
/// ここでは数値データのみ持つ。
class DailyDigest {
  const DailyDigest({
    required this.day,
    required this.attemptsToday,
    required this.correctToday,
    required this.currentStreakDays,
  });

  final DateTime day;
  final int attemptsToday;
  final int correctToday;

  /// `LearningStreak`の現在のストリーク（何日連続で学習したか）。
  final int currentStreakDays;

  double get accuracy => attemptsToday == 0 ? 0 : correctToday / attemptsToday;
}
