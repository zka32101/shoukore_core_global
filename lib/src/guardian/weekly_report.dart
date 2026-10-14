import '../clock/clock.dart';
import '../models/models.dart';
import '../progress/progress_store.dart';
import '../weak/weak_notes.dart';

/// 単元ごとの週次集計。
class WeeklyReportUnit {
  const WeeklyReportUnit({
    required this.unitId,
    required this.attemptCount,
    required this.correctCount,
    this.topMisconception,
  });

  final String unitId;
  final int attemptCount;
  final int correctCount;

  /// 期間内で最も頻出した誤解タイプ（無ければnull）。
  final String? topMisconception;

  double get accuracy => attemptCount == 0 ? 0 : correctCount / attemptCount;
}

/// 保護者向け週次レポート。文言化（arb）はアプリ側の責務とし、ここではデータのみ持つ。
class WeeklyReport {
  const WeeklyReport({
    required this.periodStart,
    required this.periodEnd,
    required this.totalAttempts,
    required this.totalCorrect,
    required this.units,
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalAttempts;
  final int totalCorrect;
  final List<WeeklyReportUnit> units;

  double get overallAccuracy => totalAttempts == 0 ? 0 : totalCorrect / totalAttempts;
}

/// `ProgressStore`から直近期間の記録を集計し、保護者向け週次レポートを組み立てる。
class WeeklyReportBuilder {
  const WeeklyReportBuilder({this.weakNotesAnalyzer = const WeakNotesAnalyzer()});

  final WeakNotesAnalyzer weakNotesAnalyzer;

  Future<WeeklyReport> build({
    required ProgressStore progressStore,
    required List<String> unitIds,
    required Clock clock,
    required Question Function(String questionId) questionLookup,
    int periodDays = 7,
  }) async {
    final now = clock.now();
    final periodStart = now.subtract(Duration(days: periodDays));

    final units = <WeeklyReportUnit>[];
    var totalAttempts = 0;
    var totalCorrect = 0;

    for (final unitId in unitIds) {
      final attempts = await progressStore.getAttempts(unitId);
      final inPeriod = attempts
          .where((a) => !a.answeredAt.isBefore(periodStart) && !a.answeredAt.isAfter(now))
          .toList();
      if (inPeriod.isEmpty) continue;

      final correctCount = inPeriod.where((a) => a.correct).length;
      final note = weakNotesAnalyzer.analyze(
        unitId: unitId,
        attempts: inPeriod,
        questionLookup: questionLookup,
      );

      units.add(WeeklyReportUnit(
        unitId: unitId,
        attemptCount: inPeriod.length,
        correctCount: correctCount,
        topMisconception: weakNotesAnalyzer.topMisconception(note),
      ));

      totalAttempts += inPeriod.length;
      totalCorrect += correctCount;
    }

    return WeeklyReport(
      periodStart: periodStart,
      periodEnd: now,
      totalAttempts: totalAttempts,
      totalCorrect: totalCorrect,
      units: units,
    );
  }
}
