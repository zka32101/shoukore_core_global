import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SyncConflictResolutionChoiceBiasDetector', () {
    const detector = SyncConflictResolutionChoiceBiasDetector(consecutiveCountThreshold: 3);

    test('同じ側が連続して採用されていれば偏りと判定', () {
      final history = [false, true, true, true];
      expect(detector.hasBias(history), isTrue);
    });

    test('採用される側が混在していれば偏りではない', () {
      final history = [true, false, true, false];
      expect(detector.hasBias(history), isFalse);
    });

    test('履歴が閾値未満なら偏りではない', () {
      final history = [true, true];
      expect(detector.hasBias(history), isFalse);
    });
  });
}
