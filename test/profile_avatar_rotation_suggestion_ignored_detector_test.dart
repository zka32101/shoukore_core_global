import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ProfileAvatarRotationSuggestionIgnoredDetector', () {
    const detector = ProfileAvatarRotationSuggestionIgnoredDetector(
      ignoredThreshold: 3,
    );

    test('連続無視回数が閾値以上なら連続無視と判定', () {
      expect(detector.isPersistentlyIgnored(3), isTrue);
      expect(detector.isPersistentlyIgnored(5), isTrue);
    });

    test('連続無視回数が閾値未満なら連続無視ではない', () {
      expect(detector.isPersistentlyIgnored(2), isFalse);
    });

    test('連続無視回数が0なら連続無視ではない', () {
      expect(detector.isPersistentlyIgnored(0), isFalse);
    });
  });
}
