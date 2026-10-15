import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const manager = InventoryManager();
  const item = StoreItem(id: 'avatar_cat', priceCoins: 50);

  group('InventoryManager', () {
    test('canPurchaseは残高が足りていれば true', () {
      const wallet = CoinWallet(balance: 100);
      final ok = manager.canPurchase(
        wallet: wallet,
        inventory: InventorySnapshot.initial,
        item: item,
      );
      expect(ok, isTrue);
    });

    test('canPurchaseは残高不足なら false', () {
      const wallet = CoinWallet(balance: 10);
      final ok = manager.canPurchase(
        wallet: wallet,
        inventory: InventorySnapshot.initial,
        item: item,
      );
      expect(ok, isFalse);
    });

    test('canPurchaseは既に所持していれば false', () {
      const wallet = CoinWallet(balance: 100);
      const inventory = InventorySnapshot(ownedItemIds: {'avatar_cat'});
      final ok = manager.canPurchase(wallet: wallet, inventory: inventory, item: item);
      expect(ok, isFalse);
    });

    test('purchaseで残高が減り、所持アイテムに追加される', () {
      const wallet = CoinWallet(balance: 100);
      final result = manager.purchase(
        wallet: wallet,
        inventory: InventorySnapshot.initial,
        item: item,
      );
      expect(result.wallet.balance, 50);
      expect(result.inventory.owns('avatar_cat'), isTrue);
    });

    test('残高不足でpurchaseすると例外', () {
      const wallet = CoinWallet(balance: 10);
      expect(
        () => manager.purchase(wallet: wallet, inventory: InventorySnapshot.initial, item: item),
        throwsStateError,
      );
    });

    test('既に所持しているアイテムをpurchaseすると例外', () {
      const wallet = CoinWallet(balance: 100);
      const inventory = InventorySnapshot(ownedItemIds: {'avatar_cat'});
      expect(
        () => manager.purchase(wallet: wallet, inventory: inventory, item: item),
        throwsStateError,
      );
    });
  });
}
