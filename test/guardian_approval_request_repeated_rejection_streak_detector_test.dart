import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianApprovalRequestRepeatedRejectionStreakDetector', () {
    const detector = GuardianApprovalRequestRepeatedRejectionStreakDetector(
      rejectionThreshold: 3,
    );

    test('連続却下回数が閾値以上なら連続却下と判定', () {
      expect(detector.isRepeatedlyRejected(3), isTrue);
      expect(detector.isRepeatedlyRejected(5), isTrue);
    });

    test('連続却下回数が閾値未満なら連続却下ではない', () {
      expect(detector.isRepeatedlyRejected(2), isFalse);
    });

    test('連続却下回数が0なら連続却下ではない', () {
      expect(detector.isRepeatedlyRejected(0), isFalse);
    });
  });
}
