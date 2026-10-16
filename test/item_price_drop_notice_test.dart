import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = ItemPriceDropNotice();
  const item = StoreItem(id: 'hat', priceCoins: 80);

  test('前回記録がない場合は通知しない', () {
    expect(notice.shouldNotify(item: item, lastSeen: null), isFalse);
  });

  test('アイテムIDが異なる場合は通知しない', () {
    const lastSeen = SeenItemPrice(itemId: 'other', priceCoins: 200);
    expect(notice.shouldNotify(item: item, lastSeen: lastSeen), isFalse);
  });

  test('価格が下がっていれば通知する', () {
    const lastSeen = SeenItemPrice(itemId: 'hat', priceCoins: 100);
    expect(notice.shouldNotify(item: item, lastSeen: lastSeen), isTrue);
  });

  test('価格が変わらないか上がっていれば通知しない', () {
    const sameSeen = SeenItemPrice(itemId: 'hat', priceCoins: 80);
    const higherSeen = SeenItemPrice(itemId: 'hat', priceCoins: 50);
    expect(notice.shouldNotify(item: item, lastSeen: sameSeen), isFalse);
    expect(notice.shouldNotify(item: item, lastSeen: higherSeen), isFalse);
  });
}
