import 'achievement.dart';

/// バッジの達成度ランク。文言はアプリ側のl10nで解決する想定で、
/// 本コアはランク（と判定ロジック）のみを保持する。
enum AchievementRank { bronze, silver, gold }

/// 保護者向け共有カード表示用のデータ。タイトル・説明文自体は持たず、
/// アプリ側がl10nで`achievementId`から文言を解決する際に使う最小限の
/// メタデータ（ID・ランク・獲得日時）のみを純関数で組み立てる。
/// 画像生成・SNS連携などの実際の共有処理はアプリ側の責務とする。
class AchievementShareCardData {
  const AchievementShareCardData({
    required this.achievementId,
    required this.rank,
    required this.unlockedAt,
  });

  final AchievementId achievementId;
  final AchievementRank rank;
  final DateTime unlockedAt;
}

/// `AchievementId`から共有カードデータを組み立てる純関数。
class AchievementShareCardBuilder {
  const AchievementShareCardBuilder();

  static const _ranks = {
    AchievementId.streakDays3: AchievementRank.bronze,
    AchievementId.streakDays7: AchievementRank.silver,
    AchievementId.streakDays30: AchievementRank.gold,
    AchievementId.correctAnswers100: AchievementRank.silver,
    AchievementId.correctAnswers500: AchievementRank.gold,
  };

  AchievementShareCardData build({
    required AchievementId achievementId,
    required DateTime unlockedAt,
  }) {
    return AchievementShareCardData(
      achievementId: achievementId,
      rank: _ranks[achievementId] ?? AchievementRank.bronze,
      unlockedAt: unlockedAt,
    );
  }
}
