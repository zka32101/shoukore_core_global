import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const flag = AnswerLatencyOutlierFlag(
    minimumPlausible: Duration(milliseconds: 300),
    maximumPlausible: Duration(minutes: 5),
  );

  test('短すぎる解答時間は異常と判定する', () {
    expect(flag.isOutlier(const Duration(milliseconds: 100)), isTrue);
  });

  test('長すぎる解答時間は異常と判定する', () {
    expect(flag.isOutlier(const Duration(minutes: 10)), isTrue);
  });

  test('妥当な範囲の解答時間は異常としない', () {
    expect(flag.isOutlier(const Duration(seconds: 10)), isFalse);
  });
}
