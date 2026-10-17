import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const alert = SessionReviewModeRatioAlert(
    minimumSampleSize: 5,
    reviewRatioThreshold: 0.8,
  );
  final now = DateTime(2024, 1, 1);

  Attempt attempt(String mode, bool correct) => Attempt(
        questionId: 'q1',
        unitId: 'u1',
        correct: correct,
        answeredAt: now,
        mode: mode,
      );

  test('件数が最小サンプル数未満なら判定しない', () {
    expect(
      alert.isTooReviewHeavy([attempt('review', true), attempt('review', true)]),
      isFalse,
    );
  });

  test('practiceが中心であれば偏りと判定しない', () {
    expect(
      alert.isTooReviewHeavy([
        attempt('practice', true),
        attempt('practice', true),
        attempt('practice', true),
        attempt('review', true),
        attempt('practice', true),
      ]),
      isFalse,
    );
  });

  test('reviewが8割以上なら偏りと判定する', () {
    expect(
      alert.isTooReviewHeavy([
        attempt('review', true),
        attempt('review', true),
        attempt('review', true),
        attempt('review', true),
        attempt('practice', true),
      ]),
      isTrue,
    );
  });
}
