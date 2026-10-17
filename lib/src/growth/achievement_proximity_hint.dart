import 'achievement.dart';
import 'growth_snapshot.dart';

/// `AchievementEvaluator`が判定する各バッジについて、現在の進捗が解除条件に
/// どれだけ近いかを算出する純関数。`AchievementEvaluator`自体は「解除済み
/// かどうか」の二値判定のみを行い、未解除のバッジが条件まであとどれだけか
/// は見ないため、本クラスが残り必要な回数を算出する。実際の「もうすぐ
/// 解除！」のようなUI表示はアプリ側の責務とする。
class AchievementProximityHint {
  const AchievementProximityHint();

  static const _streakThresholds = <AchievementId, int>{
    AchievementId.streakDays3: 3,
    AchievementId.streakDays7: 7,
    AchievementId.streakDays30: 30,
  };

  static const _correctAnswerThresholds = <AchievementId, int>{
    AchievementId.correctAnswers100: 100,
    AchievementId.correctAnswers500: 500,
  };

  /// まだ解除されていないバッジのうち、[snapshot]の現在値から見て
  /// 条件達成まで残り何回（または何日）必要かのマップを返す。解除済みの
  /// バッジは含めない。
  Map<AchievementId, int> remainingToUnlock(GrowthSnapshot snapshot) {
    final unlocked = const AchievementEvaluator().evaluate(snapshot);
    final remaining = <AchievementId, int>{};

    for (final entry in _streakThresholds.entries) {
      if (unlocked.contains(entry.key)) continue;
      remaining[entry.key] = entry.value - snapshot.currentStreakDays;
    }

    for (final entry in _correctAnswerThresholds.entries) {
      if (unlocked.contains(entry.key)) continue;
      remaining[entry.key] = entry.value - snapshot.totalCorrectAnswers;
    }

    return remaining;
  }

  /// 未解除のバッジの中で、残りが最も少ない（最も近い）ものを返す。
  /// 未解除のバッジがなければ`null`を返す。
  AchievementId? closestUnlockedCandidate(GrowthSnapshot snapshot) {
    final remaining = remainingToUnlock(snapshot);
    if (remaining.isEmpty) return null;

    var closest = remaining.entries.first;
    for (final entry in remaining.entries) {
      if (entry.value < closest.value) closest = entry;
    }
    return closest.key;
  }
}
