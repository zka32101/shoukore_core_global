import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ProfileAvatarChangeFrequencyThrottle', () {
    test('時間枠内に最大回数を超えると変更を制限する', () {
      const throttle = ProfileAvatarChangeFrequencyThrottle(maxChangesInWindow: 2);
      final start = DateTime(2026, 1, 1, 12, 0);

      var state = ProfileAvatarChangeState.initial;
      state = throttle.recordChange(state, start);
      state = throttle.recordChange(state, start.add(const Duration(seconds: 10)));

      final allowed = throttle.canChange(state, start.add(const Duration(seconds: 20)));

      expect(allowed, isFalse);
    });

    test('時間枠を過ぎれば再び変更を許可する', () {
      const throttle = ProfileAvatarChangeFrequencyThrottle(
        window: Duration(minutes: 1),
        maxChangesInWindow: 1,
      );
      final start = DateTime(2026, 1, 1, 12, 0);

      var state = ProfileAvatarChangeState.initial;
      state = throttle.recordChange(state, start);

      final allowed = throttle.canChange(state, start.add(const Duration(minutes: 2)));

      expect(allowed, isTrue);
    });

    test('初回は常に変更を許可する', () {
      const throttle = ProfileAvatarChangeFrequencyThrottle();

      final allowed = throttle.canChange(ProfileAvatarChangeState.initial, DateTime(2026, 1, 1));

      expect(allowed, isTrue);
    });
  });
}
