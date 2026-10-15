import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const lockout = GuardianGateLockout(maxAttempts: 3, lockoutDuration: Duration(minutes: 5));
  final now = DateTime.utc(2026, 10, 15, 10);

  group('GuardianGateLockout', () {
    test('初期状態ではロックされていない', () {
      expect(lockout.isLocked(GuardianGateLockoutState.initial, now), isFalse);
    });

    test('maxAttempts未満の失敗ではロックされない', () {
      var state = GuardianGateLockoutState.initial;
      state = lockout.recordFailure(state, now);
      state = lockout.recordFailure(state, now);

      expect(state.failureCount, 2);
      expect(lockout.isLocked(state, now), isFalse);
    });

    test('maxAttempts回連続で失敗するとロックされる', () {
      var state = GuardianGateLockoutState.initial;
      for (var i = 0; i < 3; i++) {
        state = lockout.recordFailure(state, now);
      }

      expect(lockout.isLocked(state, now), isTrue);
      expect(state.failureCount, 0);
      expect(state.lockedUntil, now.add(const Duration(minutes: 5)));
    });

    test('lockoutDuration経過後はロックが解除される', () {
      var state = GuardianGateLockoutState.initial;
      for (var i = 0; i < 3; i++) {
        state = lockout.recordFailure(state, now);
      }

      final afterLockout = now.add(const Duration(minutes: 5, seconds: 1));
      expect(lockout.isLocked(state, afterLockout), isFalse);
    });

    test('recordSuccessで失敗回数・ロックアウトがリセットされる', () {
      var state = GuardianGateLockoutState.initial;
      state = lockout.recordFailure(state, now);
      state = lockout.recordFailure(state, now);
      state = lockout.recordSuccess();

      expect(state.failureCount, 0);
      expect(state.lockedUntil, isNull);
    });
  });
}
