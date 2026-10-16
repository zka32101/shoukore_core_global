import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const guard = InventoryDuplicateGiftGuard();

  test('未所持のアイテムは付与をブロックしない', () {
    const inventory = InventorySnapshot(ownedItemIds: {'hat'});
    expect(guard.shouldBlockGift(inventory: inventory, itemId: 'scarf'), isFalse);
  });

  test('既に所持しているアイテムは付与をブロックする', () {
    const inventory = InventorySnapshot(ownedItemIds: {'hat'});
    expect(guard.shouldBlockGift(inventory: inventory, itemId: 'hat'), isTrue);
  });

  test('空のインベントリならブロックしない', () {
    expect(
      guard.shouldBlockGift(inventory: InventorySnapshot.initial, itemId: 'hat'),
      isFalse,
    );
  });
}
