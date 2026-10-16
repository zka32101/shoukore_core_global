import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const alert = QuestionDifficultyDriftAlert(driftThreshold: 0.4);

  test('変化量が閾値未満ならアラート対象外', () {
    expect(
      alert.isDrifting(previousDifficulty: 0.3, currentDifficulty: 0.5),
      isFalse,
    );
  });

  test('変化量が閾値以上ならアラート対象', () {
    expect(
      alert.isDrifting(previousDifficulty: 0.2, currentDifficulty: 0.7),
      isTrue,
    );
  });

  test('下降方向の変化も絶対値で判定する', () {
    expect(
      alert.isDrifting(previousDifficulty: 0.9, currentDifficulty: 0.4),
      isTrue,
    );
  });
}
