import '../clock/clock.dart';
import '../growth/daily_boundary.dart';
import '../growth/growth_snapshot.dart';
import '../progress/progress_store.dart';
import 'daily_digest.dart';

/// `ProgressStore`から今日分の記録を集計し、保護者向けの日次要約を組み立てる。
/// `WeeklyReportBuilder`の日次版で、`NotificationScheduler`経由で毎日決まった
/// 時間に送る通知の元データとして使う想定（実際の通知文言・送信はアプリ側）。
class DailyDigestBuilder {
  const DailyDigestBuilder();

  Future<DailyDigest> build({
    required ProgressStore progressStore,
    required List<String> unitIds,
    required GrowthSnapshot growthSnapshot,
    required Clock clock,
    required DailyBoundary boundary,
  }) async {
    final now = clock.now();
    final today = boundary.missionDayOf(now);

    var attemptsToday = 0;
    var correctToday = 0;

    for (final unitId in unitIds) {
      final attempts = await progressStore.getAttempts(unitId);
      for (final attempt in attempts) {
        if (!boundary.isSameMissionDay(attempt.answeredAt, today)) continue;
        attemptsToday++;
        if (attempt.correct) correctToday++;
      }
    }

    return DailyDigest(
      day: today,
      attemptsToday: attemptsToday,
      correctToday: correctToday,
      currentStreakDays: growthSnapshot.currentStreakDays,
    );
  }
}
