/// `AchievementUnlockClusterDetector`が同時解除の密集を検知した結果が、
/// 単発ではなく評価のたびに繰り返し検出され続けているかを判定する純
/// 関数。`AchievementUnlockClusterDetector`自体は1回の評価での同時解除
/// 数のみを見るため、密集の発生自体が繰り返されているかは見ない。実際
/// の祝賀表示の分散・順序付けの見直しはアプリ側の責務とする。
class AchievementUnlockClusterRecurrenceDetector {
  const AchievementUnlockClusterRecurrenceDetector({
    this.recurrenceThreshold = 3,
  }) : assert(recurrenceThreshold > 0);

  final int recurrenceThreshold;

  bool isRecurring(int consecutiveClusterCount) {
    return consecutiveClusterCount >= recurrenceThreshold;
  }
}
