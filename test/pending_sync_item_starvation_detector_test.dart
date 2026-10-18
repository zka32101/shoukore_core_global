import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('PendingSyncItemStarvationDetector', () {
    test('1時間以上経過したアイテムをスタベーションと判定する', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final clock = FixedClock(now);
      final detector = PendingSyncItemStarvationDetector(clock: clock);

      final items = [
        PendingSyncItem(
          id: 'fresh',
          payload: const {},
          createdAt: now.subtract(const Duration(minutes: 10)),
        ),
        PendingSyncItem(
          id: 'starved',
          payload: const {},
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
      ];

      final result = detector.starvedItems(items);

      expect(result.map((i) => i.id), ['starved']);
    });

    test('全アイテムが閾値未満ならスタベーションなしと判定する', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final clock = FixedClock(now);
      final detector = PendingSyncItemStarvationDetector(clock: clock);

      final items = [
        PendingSyncItem(
          id: 'a',
          payload: const {},
          createdAt: now.subtract(const Duration(minutes: 5)),
        ),
      ];

      expect(detector.hasStarvedItem(items), isFalse);
    });

    test('ちょうど閾値の経過時間はスタベーションと判定する', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final clock = FixedClock(now);
      final detector = PendingSyncItemStarvationDetector(clock: clock);

      final items = [
        PendingSyncItem(
          id: 'exact',
          payload: const {},
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
      ];

      expect(detector.hasStarvedItem(items), isTrue);
    });
  });
}
