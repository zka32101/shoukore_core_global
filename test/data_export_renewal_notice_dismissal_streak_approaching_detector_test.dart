import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('DataExportRenewalNoticeDismissalStreakApproachingDetector', () {
    const detector = DataExportRenewalNoticeDismissalStreakApproachingDetector(
      marginRatio: 0.2,
    );

    test('閾値未満かつマージン内であれば接近状態と判定', () {
      expect(
        detector.isApproaching(
          consecutiveDismissalCount: 4,
          dismissalThreshold: 5,
        ),
        isTrue,
      );
    });

    test('マージン外であれば接近状態ではない', () {
      expect(
        detector.isApproaching(
          consecutiveDismissalCount: 1,
          dismissalThreshold: 5,
        ),
        isFalse,
      );
    });

    test('閾値以上であれば接近状態ではない(すでに到達済み)', () {
      expect(
        detector.isApproaching(
          consecutiveDismissalCount: 5,
          dismissalThreshold: 5,
        ),
        isFalse,
      );
    });
  });
}
