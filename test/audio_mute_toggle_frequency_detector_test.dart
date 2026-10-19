import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AudioMuteToggleFrequencyDetector', () {
    const detector = AudioMuteToggleFrequencyDetector(
      toggleCountThreshold: 4,
      observationWindow: Duration(minutes: 10),
    );
    final now = DateTime(2024, 1, 1, 12, 0);

    test('観測期間内の切り替え回数が閾値以上なら頻発と判定', () {
      final timestamps = [
        now.subtract(const Duration(minutes: 1)),
        now.subtract(const Duration(minutes: 3)),
        now.subtract(const Duration(minutes: 5)),
        now.subtract(const Duration(minutes: 7)),
      ];
      expect(
        detector.isTogglingFrequently(toggledAtTimestamps: timestamps, now: now),
        isTrue,
      );
    });

    test('観測期間内の切り替え回数が閾値未満なら頻発ではない', () {
      final timestamps = [
        now.subtract(const Duration(minutes: 1)),
        now.subtract(const Duration(minutes: 3)),
      ];
      expect(
        detector.isTogglingFrequently(toggledAtTimestamps: timestamps, now: now),
        isFalse,
      );
    });

    test('観測期間外の切り替えは件数に含めない', () {
      final timestamps = [
        now.subtract(const Duration(minutes: 1)),
        now.subtract(const Duration(minutes: 3)),
        now.subtract(const Duration(minutes: 20)),
        now.subtract(const Duration(minutes: 30)),
      ];
      expect(
        detector.isTogglingFrequently(toggledAtTimestamps: timestamps, now: now),
        isFalse,
      );
    });
  });
}
