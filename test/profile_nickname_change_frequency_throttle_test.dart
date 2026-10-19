import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ProfileNicknameChangeFrequencyThrottle', () {
    const throttle = ProfileNicknameChangeFrequencyThrottle(
      window: Duration(minutes: 1),
      maxChangesInWindow: 2,
    );

    test('初回は常に変更を許可する', () {
      expect(
        throttle.canChange(ProfileNicknameChangeState.initial, DateTime(2024, 1, 1)),
        isTrue,
      );
    });

    test('時間枠内に上限回数まで変更すると以降は拒否する', () {
      final now = DateTime(2024, 1, 1, 10, 0, 0);
      var state = ProfileNicknameChangeState.initial;
      state = throttle.recordChange(state, now);
      state = throttle.recordChange(state, now.add(const Duration(seconds: 10)));
      expect(throttle.canChange(state, now.add(const Duration(seconds: 20))), isFalse);
    });

    test('時間枠を過ぎれば再び変更を許可する', () {
      final now = DateTime(2024, 1, 1, 10, 0, 0);
      var state = ProfileNicknameChangeState.initial;
      state = throttle.recordChange(state, now);
      state = throttle.recordChange(state, now.add(const Duration(seconds: 10)));
      expect(throttle.canChange(state, now.add(const Duration(minutes: 2))), isTrue);
    });
  });
}
