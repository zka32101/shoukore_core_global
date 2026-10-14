import 'package:flutter/material.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

import 'l10n/app_localizations.dart';
import 'question_cache.dart';

class WeeklyReportScreen extends StatefulWidget {
  const WeeklyReportScreen({
    super.key,
    required this.unitIds,
    required this.progressStore,
    required this.clock,
    required this.questionCache,
  });

  final List<String> unitIds;
  final ProgressStore progressStore;
  final Clock clock;
  final QuestionCache questionCache;

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  static const _builder = WeeklyReportBuilder();

  WeeklyReport? _report;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final report = await _builder.build(
      progressStore: widget.progressStore,
      unitIds: widget.unitIds,
      clock: widget.clock,
      questionLookup: widget.questionCache.lookup,
    );
    if (!mounted) return;
    setState(() => _report = report);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final report = _report;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.weeklyReportTitle)),
      body: report == null
          ? const Center(child: CircularProgressIndicator())
          : report.totalAttempts == 0
              ? Center(
                  key: const Key('weeklyReportNoDataText'),
                  child: Text(l10n.weeklyReportNoData),
                )
              : ListView(
                  key: const Key('weeklyReportList'),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      l10n.weeklyReportAccuracy(
                        (report.overallAccuracy * 100).round(),
                        report.totalCorrect,
                        report.totalAttempts,
                      ),
                      key: const Key('weeklyReportAccuracyText'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    for (final unit in report.units)
                      Padding(
                        key: Key('weeklyReportUnit_${unit.unitId}'),
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.weeklyReportUnitLine(
                              unit.unitId,
                              (unit.accuracy * 100).round(),
                              unit.correctCount,
                              unit.attemptCount,
                            )),
                            if (unit.topMisconception != null)
                              Text(
                                l10n.weeklyReportTopMisconception(unit.topMisconception!),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }
}
