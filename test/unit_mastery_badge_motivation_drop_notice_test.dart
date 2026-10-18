import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('UnitMasteryBadgeMotivationDropNotice', () {
    const notice = UnitMasteryBadgeMotivationDropNotice(inactivityThreshold: Duration(days: 3));
    final masteredAt = DateTime(2026, 10, 1);

    test('マスター達成後、閾値以上その単元に触れていなければtrue', () {
      final now = masteredAt.add(const Duration(days: 4));
      expect(notice.isMotivationDropped(masteredAt: masteredAt, now: now), isTrue);
    });

    test('マスター達成直後なら意欲低下とはみなさずfalse', () {
      final now = masteredAt.add(const Duration(hours: 1));
      expect(notice.isMotivationDropped(masteredAt: masteredAt, now: now), isFalse);
    });

    test('閾値ちょうどならtrue', () {
      final now = masteredAt.add(const Duration(days: 3));
      expect(notice.isMotivationDropped(masteredAt: masteredAt, now: now), isTrue);
    });
  });
}
