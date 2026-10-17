import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('UnitDifficultyOrderValidator', () {
    const validator = UnitDifficultyOrderValidator();

    test('難易度が単調に上がっていれば逆転なし', () {
      final entries = [
        const UnitDifficultyOrderEntry(unitId: 'u1', order: 1, difficulty: 0.1),
        const UnitDifficultyOrderEntry(unitId: 'u2', order: 2, difficulty: 0.3),
        const UnitDifficultyOrderEntry(unitId: 'u3', order: 3, difficulty: 0.5),
      ];
      expect(validator.findOrderInversions(entries), isEmpty);
    });

    test('途中で難易度が下がっている単元を逆転として検出する', () {
      final entries = [
        const UnitDifficultyOrderEntry(unitId: 'u1', order: 1, difficulty: 0.2),
        const UnitDifficultyOrderEntry(unitId: 'u2', order: 2, difficulty: 0.6),
        const UnitDifficultyOrderEntry(unitId: 'u3', order: 3, difficulty: 0.3),
      ];
      expect(validator.findOrderInversions(entries), ['u3']);
    });

    test('toleranceの範囲内の低下は逆転とみなさない', () {
      const tolerantValidator = UnitDifficultyOrderValidator(tolerance: 0.1);
      final entries = [
        const UnitDifficultyOrderEntry(unitId: 'u1', order: 1, difficulty: 0.5),
        const UnitDifficultyOrderEntry(unitId: 'u2', order: 2, difficulty: 0.45),
      ];
      expect(tolerantValidator.findOrderInversions(entries), isEmpty);
    });

    test('入力の並び順に関わらずorderでソートして判定する', () {
      final entries = [
        const UnitDifficultyOrderEntry(unitId: 'u2', order: 2, difficulty: 0.8),
        const UnitDifficultyOrderEntry(unitId: 'u1', order: 1, difficulty: 0.1),
      ];
      expect(validator.findOrderInversions(entries), isEmpty);
    });
  });
}
