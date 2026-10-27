import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CrossPromoDismissalCooldown', () {
    const cooldown = CrossPromoDismissalCooldown(
      cooldownDuration: Duration(days: 7),
    );
    final now = DateTime(2026, 1, 10);

    test('無視履歴がなければ常に表示可能', () {
      expect(cooldown.isCooldownOver(null, now), isTrue);
    });

    test('クールダウン期間を過ぎていれば表示可能', () {
      expect(
        cooldown.isCooldownOver(DateTime(2026, 1, 1), now),
        isTrue,
      );
    });

    test('クールダウン期間中は表示不可', () {
      expect(
        cooldown.isCooldownOver(DateTime(2026, 1, 8), now),
        isFalse,
      );
    });
  });
}
