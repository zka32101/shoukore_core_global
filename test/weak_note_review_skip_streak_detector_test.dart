import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeakNoteReviewSkipStreakDetector', () {
    const detector = WeakNoteReviewSkipStreakDetector(skipThreshold: 3);

    test('連続スキップ回数が閾値以上なら連続スキップと判定', () {
      expect(detector.isPersistentlySkipped(3), isTrue);
      expect(detector.isPersistentlySkipped(5), isTrue);
    });

    test('連続スキップ回数が閾値未満なら連続スキップではない', () {
      expect(detector.isPersistentlySkipped(2), isFalse);
    });

    test('連続スキップ回数が0なら連続スキップではない', () {
      expect(detector.isPersistentlySkipped(0), isFalse);
    });
  });
}
