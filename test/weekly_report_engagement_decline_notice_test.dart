import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = WeeklyReportEngagementDeclineNotice(
    minimumSampleSize: 4,
    readRateThreshold: 0.25,
  );

  test('件数が最小サンプル数未満なら判定しない', () {
    expect(notice.shouldSuggestReview([false, false]), isFalse);
  });

  test('既読率が十分高ければ見直しを提案しない', () {
    expect(notice.shouldSuggestReview([true, true, false, true]), isFalse);
  });

  test('既読率が低ければ見直しを提案する', () {
    expect(notice.shouldSuggestReview([false, false, false, true]), isTrue);
  });
}
