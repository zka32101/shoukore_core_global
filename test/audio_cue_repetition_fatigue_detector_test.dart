import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AudioCueRepetitionFatigueDetector', () {
    const detector = AudioCueRepetitionFatigueDetector(repetitionThreshold: 3);

    test('同一cueIdが閾値以上出現すれば疲労と判定', () {
      final ids = ['correct', 'wrong', 'correct', 'correct', 'tap'];
      expect(detector.isFatigued(ids), isTrue);
    });

    test('同一cueIdの出現回数が閾値未満なら疲労ではない', () {
      final ids = ['correct', 'wrong', 'correct', 'tap'];
      expect(detector.isFatigued(ids), isFalse);
    });

    test('空リストなら疲労と判定しない', () {
      expect(detector.isFatigued(const []), isFalse);
    });
  });
}
