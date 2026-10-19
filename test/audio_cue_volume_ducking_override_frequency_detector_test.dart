import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AudioCueVolumeDuckingOverrideFrequencyDetector', () {
    const detector = AudioCueVolumeDuckingOverrideFrequencyDetector(
      overrideCountThreshold: 3,
    );

    test('上書き回数が閾値以上なら頻発と判定', () {
      final flags = [true, false, true, true];
      expect(detector.isFrequentlyOverridden(flags), isTrue);
    });

    test('上書き回数が閾値未満なら頻発ではない', () {
      final flags = [true, false, true, false];
      expect(detector.isFrequentlyOverridden(flags), isFalse);
    });

    test('空リストなら頻発ではない', () {
      expect(detector.isFrequentlyOverridden(const []), isFalse);
    });
  });
}
