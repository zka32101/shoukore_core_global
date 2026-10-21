import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeakNoteBacklogSizeAlertDismissalStreakDetector', () {
    const detector = WeakNoteBacklogSizeAlertDismissalStreakDetector(dismissalThreshold: 3);

    test('連続無視回数が閾値以上なら連続無視状態と判定', () {
      expect(detector.isPersistentlyDismissed(3), isTrue);
      expect(detector.isPersistentlyDismissed(5), isTrue);
    });

    test('連続無視回数が閾値未満なら連続無視状態ではない', () {
      expect(detector.isPersistentlyDismissed(2), isFalse);
    });

    test('連続無視回数が0なら連続無視状態ではない', () {
      expect(detector.isPersistentlyDismissed(0), isFalse);
    });
  });
}
