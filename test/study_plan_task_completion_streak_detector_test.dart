import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StudyPlanTaskCompletionStreakDetector', () {
    const detector = StudyPlanTaskCompletionStreakDetector(onTrackThreshold: 3);

    test('閾値以上なら順調', () {
      expect(detector.isOnTrack(3), isTrue);
      expect(detector.isOnTrack(5), isTrue);
    });

    test('閾値未満なら順調ではない', () {
      expect(detector.isOnTrack(2), isFalse);
      expect(detector.isOnTrack(0), isFalse);
    });
  });
}
