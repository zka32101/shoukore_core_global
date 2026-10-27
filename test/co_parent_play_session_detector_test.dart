import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CoParentPlaySessionDetector', () {
    const detector = CoParentPlaySessionDetector(
      minGuardianInteractionCount: 1,
    );

    test('保護者操作回数が閾値以上であれば親子参加セッションと判定', () {
      expect(detector.isCoParentSession(1), isTrue);
    });

    test('保護者操作回数が閾値未満であれば親子参加セッションではない', () {
      expect(detector.isCoParentSession(0), isFalse);
    });

    test('保護者操作回数が多くても親子参加セッションと判定', () {
      expect(detector.isCoParentSession(5), isTrue);
    });
  });
}
