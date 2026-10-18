import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('FlakyConnectivityDetector', () {
    const detector = FlakyConnectivityDetector(
      shortOnlineDuration: Duration(seconds: 30),
      flakyOccurrenceThreshold: 3,
    );

    test('直近3件すべて短いオンライン区間なら不安定と判定', () {
      final durations = [
        const Duration(seconds: 5),
        const Duration(seconds: 10),
        const Duration(seconds: 20),
      ];
      expect(detector.isFlaky(durations), isTrue);
    });

    test('直近3件に十分長いオンライン区間が混ざっていれば不安定ではない', () {
      final durations = [
        const Duration(seconds: 5),
        const Duration(minutes: 10),
        const Duration(seconds: 20),
      ];
      expect(detector.isFlaky(durations), isFalse);
    });

    test('件数が閾値未満なら不安定と判定しない', () {
      final durations = [const Duration(seconds: 5)];
      expect(detector.isFlaky(durations), isFalse);
    });
  });
}
