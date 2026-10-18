import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianGateLockoutEndingSoonNotice', () {
    const notice = GuardianGateLockoutEndingSoonNotice(remainingTimeThreshold: Duration(seconds: 30));
    final now = DateTime(2026, 10, 18, 12, 0, 0);

    test('locked状態で残り時間が閾値以内ならtrue', () {
      final state = GuardianGateLockoutState(failureCount: 0, lockedUntil: now.add(const Duration(seconds: 10)));
      expect(notice.isEndingSoon(state: state, now: now), isTrue);
    });

    test('locked状態でも残り時間が閾値を超えていればfalse', () {
      final state = GuardianGateLockoutState(failureCount: 0, lockedUntil: now.add(const Duration(minutes: 5)));
      expect(notice.isEndingSoon(state: state, now: now), isFalse);
    });

    test('ロックされていない状態ならfalse', () {
      expect(notice.isEndingSoon(state: GuardianGateLockoutState.initial, now: now), isFalse);
    });
  });
}
