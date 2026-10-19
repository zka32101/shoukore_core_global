import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AchievementShareCardCooldown', () {
    const cooldown = AchievementShareCardCooldown(cooldown: Duration(minutes: 5));

    test('一度も共有していなければ常に許可する', () {
      expect(
        cooldown.canShare(AchievementShareCardCooldownState.initial, DateTime(2024, 1, 1)),
        isTrue,
      );
    });

    test('クールダウン中は共有を拒否する', () {
      final now = DateTime(2024, 1, 1, 10, 0, 0);
      final state = cooldown.recordShare(now);
      expect(cooldown.canShare(state, now.add(const Duration(minutes: 1))), isFalse);
    });

    test('クールダウンが過ぎれば再び共有を許可する', () {
      final now = DateTime(2024, 1, 1, 10, 0, 0);
      final state = cooldown.recordShare(now);
      expect(cooldown.canShare(state, now.add(const Duration(minutes: 6))), isTrue);
    });
  });
}
