import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AdaptiveDifficultyPlateauDetector', () {
    const detector = AdaptiveDifficultyPlateauDetector(plateauThreshold: 5);

    test('直近5件が全て同じ難易度なら停滞と判定', () {
      final recent = [0.5, 0.5, 0.5, 0.5, 0.5];
      expect(detector.isPlateaued(recent), isTrue);
    });

    test('直近5件に異なる値が混ざっていれば停滞ではない', () {
      final recent = [0.5, 0.5, 0.6, 0.5, 0.5];
      expect(detector.isPlateaued(recent), isFalse);
    });

    test('件数が閾値未満なら停滞と判定しない', () {
      final recent = [0.5, 0.5];
      expect(detector.isPlateaued(recent), isFalse);
    });
  });
}
