import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const policy = SessionTimeoutPolicy(timeout: Duration(minutes: 5));

  group('shouldLock', () {
    test('timeout以内はfalse', () {
      final lastInteractionAt = DateTime(2024, 1, 1, 0, 0, 0);
      expect(policy.shouldLock(lastInteractionAt, DateTime(2024, 1, 1, 0, 3, 0)), isFalse);
    });

    test('timeoutを超えればtrue', () {
      final lastInteractionAt = DateTime(2024, 1, 1, 0, 0, 0);
      expect(policy.shouldLock(lastInteractionAt, DateTime(2024, 1, 1, 0, 6, 0)), isTrue);
    });
  });

  group('remainingUntilLock', () {
    test('ロック済みならゼロ', () {
      final lastInteractionAt = DateTime(2024, 1, 1, 0, 0, 0);
      expect(
        policy.remainingUntilLock(lastInteractionAt, DateTime(2024, 1, 1, 0, 6, 0)),
        Duration.zero,
      );
    });

    test('未満なら残り時間を返す', () {
      final lastInteractionAt = DateTime(2024, 1, 1, 0, 0, 0);
      expect(
        policy.remainingUntilLock(lastInteractionAt, DateTime(2024, 1, 1, 0, 3, 0)),
        const Duration(minutes: 2),
      );
    });
  });
}
