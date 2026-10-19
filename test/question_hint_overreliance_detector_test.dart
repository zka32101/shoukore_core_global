import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('QuestionHintOverrelianceDetector', () {
    const detector = QuestionHintOverrelianceDetector(usageCountThreshold: 3);

    test('ヒント利用回数が閾値以上なら過度な依存と判定', () {
      final flags = [true, false, true, true, false];
      expect(detector.isOverreliant(flags), isTrue);
    });

    test('ヒント利用回数が閾値未満なら過度な依存ではない', () {
      final flags = [true, false, true, false];
      expect(detector.isOverreliant(flags), isFalse);
    });

    test('空リストなら過度な依存ではない', () {
      expect(detector.isOverreliant(const []), isFalse);
    });
  });
}
