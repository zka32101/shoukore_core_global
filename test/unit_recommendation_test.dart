import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const recommendation = UnitRecommendation();

  test('未学習（記録なし）の単元を最優先する', () {
    final result = recommendation.recommend(
      unitIds: ['a', 'b'],
      masteryByUnitId: {'a': const Mastery(unitId: 'a', score: 0.8)},
    );
    expect(result, ['b', 'a']);
  });

  test('スコアが低い単元ほど優先する', () {
    final result = recommendation.recommend(
      unitIds: ['a', 'b', 'c'],
      masteryByUnitId: {
        'a': const Mastery(unitId: 'a', score: 0.9),
        'b': const Mastery(unitId: 'b', score: 0.2),
        'c': const Mastery(unitId: 'c', score: 0.5),
      },
    );
    expect(result, ['b', 'c', 'a']);
  });

  test('同スコアなら元の順序を保つ（安定ソート）', () {
    final result = recommendation.recommend(
      unitIds: ['a', 'b'],
      masteryByUnitId: {
        'a': const Mastery(unitId: 'a', score: 0.5),
        'b': const Mastery(unitId: 'b', score: 0.5),
      },
    );
    expect(result, ['a', 'b']);
  });

  test('topPickはrecommendの先頭を返す', () {
    final pick = recommendation.topPick(
      unitIds: ['a', 'b'],
      masteryByUnitId: {'a': const Mastery(unitId: 'a', score: 0.9)},
    );
    expect(pick, 'b');
  });

  test('topPickはunitIdsが空ならnull', () {
    final pick = recommendation.topPick(unitIds: [], masteryByUnitId: {});
    expect(pick, isNull);
  });
}
