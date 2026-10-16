import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const guard = GrowthStageRegressionGuard();

  test('新しい段階が保存済みより進んでいれば後退ではない', () {
    expect(
      guard.isRegression(storedStage: GrowthStage.baby, newStage: GrowthStage.child),
      isFalse,
    );
  });

  test('新しい段階が保存済みと同じなら後退ではない', () {
    expect(
      guard.isRegression(storedStage: GrowthStage.child, newStage: GrowthStage.child),
      isFalse,
    );
  });

  test('新しい段階が保存済みより後退していれば後退と判定する', () {
    expect(
      guard.isRegression(storedStage: GrowthStage.adult, newStage: GrowthStage.egg),
      isTrue,
    );
  });
}
