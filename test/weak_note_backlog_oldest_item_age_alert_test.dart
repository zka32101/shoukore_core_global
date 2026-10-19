import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeakNoteBacklogOldestItemAgeAlert', () {
    const alert = WeakNoteBacklogOldestItemAgeAlert(agePeriod: Duration(days: 30));
    final now = DateTime(2024, 2, 1);

    test('最古の未解消ノートの放置期間が閾値を超えていれば警告対象', () {
      expect(
        alert.shouldAlert(
          oldestUnresolvedUpdatedAt: now.subtract(const Duration(days: 31)),
          now: now,
        ),
        isTrue,
      );
    });

    test('最古の未解消ノートの放置期間が閾値以内なら警告対象ではない', () {
      expect(
        alert.shouldAlert(
          oldestUnresolvedUpdatedAt: now.subtract(const Duration(days: 10)),
          now: now,
        ),
        isFalse,
      );
    });

    test('未解消のノートが無ければ警告対象ではない', () {
      expect(
        alert.shouldAlert(oldestUnresolvedUpdatedAt: null, now: now),
        isFalse,
      );
    });
  });
}
