import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = InventoryItemExpiryNotice(noticeWindow: Duration(days: 3));
  final now = DateTime(2024, 1, 1);

  test('期限まで十分あるアイテムは対象外', () {
    expect(
      notice.itemsNearingExpiry(
        expiresAtByItemId: {'hat': now.add(const Duration(days: 10))},
        now: now,
      ),
      isEmpty,
    );
  });

  test('期限まで3日以内のアイテムは対象', () {
    expect(
      notice.itemsNearingExpiry(
        expiresAtByItemId: {'hat': now.add(const Duration(days: 2))},
        now: now,
      ),
      equals(['hat']),
    );
  });

  test('既に期限切れのアイテムは対象外', () {
    expect(
      notice.itemsNearingExpiry(
        expiresAtByItemId: {'hat': now.subtract(const Duration(days: 1))},
        now: now,
      ),
      isEmpty,
    );
  });
}
