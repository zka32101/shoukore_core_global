import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('InventoryItemStaleUsageNotice', () {
    const notice = InventoryItemStaleUsageNotice(staleAfter: Duration(days: 14));
    final now = DateTime(2026, 10, 18);

    test('最終使用から閾値以上経過したアイテムを返す', () {
      final map = {
        'item-a': now.subtract(const Duration(days: 20)),
        'item-b': now.subtract(const Duration(days: 1)),
      };
      expect(notice.findStaleItemIds(lastUsedAtByItemId: map, now: now), ['item-a']);
    });

    test('一度も使用していないアイテム（null）も返す', () {
      final map = {'item-a': null};
      expect(notice.findStaleItemIds(lastUsedAtByItemId: map, now: now), ['item-a']);
    });

    test('最近使用したアイテムは返さない', () {
      final map = {'item-a': now.subtract(const Duration(days: 1))};
      expect(notice.findStaleItemIds(lastUsedAtByItemId: map, now: now), isEmpty);
    });
  });
}
