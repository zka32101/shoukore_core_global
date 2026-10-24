import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianApprovalRequestRepeatedRejectionStreakApproachingDetector',
      () {
    const detector =
        GuardianApprovalRequestRepeatedRejectionStreakApproachingDetector(
      marginRatio: 0.2,
    );

    test('閾値未満かつマージン内であれば接近状態と判定', () {
      expect(
        detector.isApproaching(
          consecutiveRejectionCount: 4,
          rejectionThreshold: 5,
        ),
        isTrue,
      );
    });

    test('マージン外であれば接近状態ではない', () {
      expect(
        detector.isApproaching(
          consecutiveRejectionCount: 1,
          rejectionThreshold: 5,
        ),
        isFalse,
      );
    });

    test('閾値以上であれば接近状態ではない(すでに到達済み)', () {
      expect(
        detector.isApproaching(
          consecutiveRejectionCount: 5,
          rejectionThreshold: 5,
        ),
        isFalse,
      );
    });
  });
}
