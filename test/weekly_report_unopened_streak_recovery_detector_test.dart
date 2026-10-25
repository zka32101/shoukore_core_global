import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeeklyReportUnopenedStreakRecoveryDetector', () {
    const detector = WeeklyReportUnopenedStreakRecoveryDetector(
      recoveryThreshold: 2,
    );

    test('連続開封回数が閾値以上であれば解消と判定', () {
      expect(detector.isRecovered(2), isTrue);
    });

    test('連続開封回数が閾値未満であれば解消ではない', () {
      expect(detector.isRecovered(1), isFalse);
    });

    test('連続開封回数が0であれば解消ではない', () {
      expect(detector.isRecovered(0), isFalse);
    });
  });
}
