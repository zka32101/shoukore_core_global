import 'growth_snapshot.dart';

/// 達成バッジの種類。文言（タイトル・説明）はアプリ側のl10nで解決する想定で、
/// 本コアはID（と判定ロジック）のみを保持する。
enum AchievementId {
  streakDays3,
  streakDays7,
  streakDays30,
  correctAnswers100,
  correctAnswers500,
}

/// `GrowthSnapshot`（既存の永続化状態）から、達成済みのバッジ一覧を判定する
/// 純関数。バッジ自体の状態は持たず、毎回`GrowthSnapshot`から再計算する
/// （`AdaptiveDifficulty`等と同様、専用の永続化先を追加しない設計）。
class AchievementEvaluator {
  const AchievementEvaluator();

  Set<AchievementId> evaluate(GrowthSnapshot snapshot) {
    final unlocked = <AchievementId>{};
    if (snapshot.currentStreakDays >= 3) unlocked.add(AchievementId.streakDays3);
    if (snapshot.currentStreakDays >= 7) unlocked.add(AchievementId.streakDays7);
    if (snapshot.currentStreakDays >= 30) unlocked.add(AchievementId.streakDays30);
    if (snapshot.totalCorrectAnswers >= 100) unlocked.add(AchievementId.correctAnswers100);
    if (snapshot.totalCorrectAnswers >= 500) unlocked.add(AchievementId.correctAnswers500);
    return unlocked;
  }

  /// [before]から[after]への変化で新たに解除されたバッジ一覧。
  /// アプリ側で「新しくバッジを獲得した」通知を出す際に使う。
  Set<AchievementId> newlyUnlocked({
    required GrowthSnapshot before,
    required GrowthSnapshot after,
  }) {
    return evaluate(after).difference(evaluate(before));
  }
}
