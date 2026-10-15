import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const cooldown = ProfileSwitchCooldown(cooldown: Duration(seconds: 3));

  group('canSwitch', () {
    test('一度も切り替えていなければ常に許可', () {
      expect(cooldown.canSwitch(ProfileSwitchState.initial, DateTime(2024, 1, 1)), isTrue);
    });

    test('cooldown以内は不許可', () {
      final state = ProfileSwitchState(lastSwitchedAt: DateTime(2024, 1, 1, 0, 0, 0));
      expect(cooldown.canSwitch(state, DateTime(2024, 1, 1, 0, 0, 1)), isFalse);
    });

    test('cooldownを過ぎれば許可', () {
      final state = ProfileSwitchState(lastSwitchedAt: DateTime(2024, 1, 1, 0, 0, 0));
      expect(cooldown.canSwitch(state, DateTime(2024, 1, 1, 0, 0, 4)), isTrue);
    });

    test('cooldownちょうどは許可', () {
      final state = ProfileSwitchState(lastSwitchedAt: DateTime(2024, 1, 1, 0, 0, 0));
      expect(cooldown.canSwitch(state, DateTime(2024, 1, 1, 0, 0, 3)), isTrue);
    });
  });

  test('recordSwitchはlastSwitchedAtを更新した状態を返す', () {
    final now = DateTime(2024, 1, 1, 12, 0, 0);
    final state = cooldown.recordSwitch(now);
    expect(state.lastSwitchedAt, now);
    expect(cooldown.canSwitch(state, now.add(const Duration(seconds: 1))), isFalse);
  });
}
