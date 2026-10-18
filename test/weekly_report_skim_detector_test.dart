import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeeklyReportSkimDetector', () {
    const detector = WeeklyReportSkimDetector(minViewDurationPerUnit: Duration(seconds: 3));

    WeeklyReport buildReport(int unitCount) {
      return WeeklyReport(
        periodStart: DateTime(2026, 10, 1),
        periodEnd: DateTime(2026, 10, 8),
        totalAttempts: 0,
        totalCorrect: 0,
        units: List.generate(
          unitCount,
          (i) => WeeklyReportUnit(unitId: 'unit$i', attemptCount: 1, correctCount: 1),
        ),
      );
    }

    test('単元数に対して閲覧時間が短すぎれば流し見と判定', () {
      final report = buildReport(3);
      expect(
        detector.isSkimRead(report: report, viewDuration: const Duration(seconds: 2)),
        isTrue,
      );
    });

    test('単元数に対して十分な閲覧時間があれば流し見ではない', () {
      final report = buildReport(3);
      expect(
        detector.isSkimRead(report: report, viewDuration: const Duration(seconds: 10)),
        isFalse,
      );
    });

    test('単元が0件なら流し見と判定しない', () {
      final report = buildReport(0);
      expect(
        detector.isSkimRead(report: report, viewDuration: Duration.zero),
        isFalse,
      );
    });
  });
}
