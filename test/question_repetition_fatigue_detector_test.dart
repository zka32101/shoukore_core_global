import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('QuestionRepetitionFatigueDetector', () {
    const detector = QuestionRepetitionFatigueDetector(repetitionThreshold: 3);

    test('同一問題IDが閾値以上出現すれば疲労と判定', () {
      final ids = ['q1', 'q2', 'q1', 'q1', 'q3'];
      expect(detector.isFatigued(ids), isTrue);
    });

    test('同一問題IDの出現回数が閾値未満なら疲労ではない', () {
      final ids = ['q1', 'q2', 'q1', 'q3'];
      expect(detector.isFatigued(ids), isFalse);
    });

    test('空リストなら疲労と判定しない', () {
      expect(detector.isFatigued(const []), isFalse);
    });
  });
}
