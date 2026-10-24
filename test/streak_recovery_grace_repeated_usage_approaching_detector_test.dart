import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StreakRecoveryGraceRepeatedUsageApproachingDetector', () {
    const detector = StreakRecoveryGraceRepeatedUsageApproachingDetector(
      marginRatio: 0.2,
    );

    test('閾値未満かつマージン内であれば接近状態と判定', () {
      expect(
        detector.isApproaching(
          consecutiveGraceUsageCount: 4,
          repeatedUsageThreshold: 5,
        ),
        isTrue,
      );
    });

    test('マージン外であれば接近状態ではない', () {
      expect(
        detector.isApproaching(
          consecutiveGraceUsageCount: 1,
          repeatedUsageThreshold: 5,
        ),
        isFalse,
      );
    });

    test('閾値以上であれば接近状態ではない(すでに到達済み)', () {
      expect(
        detector.isApproaching(
          consecutiveGraceUsageCount: 5,
          repeatedUsageThreshold: 5,
        ),
        isFalse,
      );
    });
  });
}
