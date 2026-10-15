import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  test('mutedUntilがnullの場合はミュートされない', () {
    const window = GuardianDigestMuteWindow();
    expect(window.isMutedAt(DateTime(2024, 1, 1)), isFalse);
  });

  test('mutedUntilより前はミュート中', () {
    final window = GuardianDigestMuteWindow(mutedUntil: DateTime(2024, 1, 10));
    expect(window.isMutedAt(DateTime(2024, 1, 5)), isTrue);
  });

  test('mutedUntil以降はミュート解除', () {
    final window = GuardianDigestMuteWindow(mutedUntil: DateTime(2024, 1, 10));
    expect(window.isMutedAt(DateTime(2024, 1, 10)), isFalse);
    expect(window.isMutedAt(DateTime(2024, 1, 11)), isFalse);
  });
}
