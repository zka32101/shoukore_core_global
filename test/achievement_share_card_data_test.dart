import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const builder = AchievementShareCardBuilder();

  test('streakDays3はbronzeランクになる', () {
    final data = builder.build(
      achievementId: AchievementId.streakDays3,
      unlockedAt: DateTime(2024, 1, 1),
    );
    expect(data.rank, AchievementRank.bronze);
    expect(data.achievementId, AchievementId.streakDays3);
    expect(data.unlockedAt, DateTime(2024, 1, 1));
  });

  test('streakDays30はgoldランクになる', () {
    final data = builder.build(
      achievementId: AchievementId.streakDays30,
      unlockedAt: DateTime(2024, 1, 1),
    );
    expect(data.rank, AchievementRank.gold);
  });

  test('correctAnswers100はsilverランクになる', () {
    final data = builder.build(
      achievementId: AchievementId.correctAnswers100,
      unlockedAt: DateTime(2024, 1, 1),
    );
    expect(data.rank, AchievementRank.silver);
  });
}
