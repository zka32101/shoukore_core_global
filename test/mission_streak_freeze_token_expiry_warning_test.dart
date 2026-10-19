import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('MissionStreakFreezeTokenExpiryWarning', () {
    const warning = MissionStreakFreezeTokenExpiryWarning(
      remainingTimeThreshold: Duration(days: 3),
    );
    final now = DateTime(2026, 1, 10);

    test('残り時間が閾値以下なら失効間近と判定', () {
      final expiresAt = now.add(const Duration(days: 2));
      expect(warning.isExpiringSoon(expiresAt: expiresAt, now: now), isTrue);
    });

    test('残り時間が閾値を超えていれば失効間近ではない', () {
      final expiresAt = now.add(const Duration(days: 10));
      expect(warning.isExpiringSoon(expiresAt: expiresAt, now: now), isFalse);
    });

    test('既に失効している場合は失効間近と判定しない', () {
      final expiresAt = now.subtract(const Duration(days: 1));
      expect(warning.isExpiringSoon(expiresAt: expiresAt, now: now), isFalse);
    });
  });
}
