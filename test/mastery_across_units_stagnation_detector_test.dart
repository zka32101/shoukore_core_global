import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('MasteryAcrossUnitsStagnationDetector', () {
    const detector = MasteryAcrossUnitsStagnationDetector(scoreImprovementThreshold: 0.05);

    test('どの単元も向上していなければ停滞と判定', () {
      final previous = [
        const Mastery(unitId: 'a', score: 0.5),
        const Mastery(unitId: 'b', score: 0.6),
      ];
      final current = [
        const Mastery(unitId: 'a', score: 0.51),
        const Mastery(unitId: 'b', score: 0.6),
      ];
      expect(
        detector.isStagnant(previousMastery: previous, currentMastery: current),
        isTrue,
      );
    });

    test('1単元でも向上していれば停滞ではない', () {
      final previous = [
        const Mastery(unitId: 'a', score: 0.5),
        const Mastery(unitId: 'b', score: 0.6),
      ];
      final current = [
        const Mastery(unitId: 'a', score: 0.7),
        const Mastery(unitId: 'b', score: 0.6),
      ];
      expect(
        detector.isStagnant(previousMastery: previous, currentMastery: current),
        isFalse,
      );
    });

    test('比較可能な単元が1件もなければ停滞ではない', () {
      final previous = [const Mastery(unitId: 'a', score: 0.5)];
      final current = [const Mastery(unitId: 'b', score: 0.6)];
      expect(
        detector.isStagnant(previousMastery: previous, currentMastery: current),
        isFalse,
      );
    });
  });
}
