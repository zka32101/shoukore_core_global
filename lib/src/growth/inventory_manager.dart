import 'coin_wallet.dart';
import 'inventory_snapshot.dart';
import 'store_item.dart';

/// 購入1回の結果（更新後のコイン残高・所持アイテム）。
class PurchaseResult {
  const PurchaseResult({required this.wallet, required this.inventory});

  final CoinWallet wallet;
  final InventorySnapshot inventory;
}

/// コインでアイテムを購入する際の判定・状態遷移を行う純関数。
/// `CoinWallet`/`InventorySnapshot`はいずれもimmutableな値であり、
/// 永続化はアプリ側（`GrowthStore`/`InventoryStore`）の責務。
class InventoryManager {
  const InventoryManager();

  bool canPurchase({
    required CoinWallet wallet,
    required InventorySnapshot inventory,
    required StoreItem item,
  }) {
    if (inventory.owns(item.id)) return false;
    return wallet.balance >= item.priceCoins;
  }

  /// [item]を購入する。既に所持している場合や残高不足の場合は`StateError`。
  PurchaseResult purchase({
    required CoinWallet wallet,
    required InventorySnapshot inventory,
    required StoreItem item,
  }) {
    if (inventory.owns(item.id)) {
      throw StateError('already owns item: ${item.id}');
    }
    final nextWallet = wallet.spend(item.priceCoins);
    final nextInventory = InventorySnapshot(
      ownedItemIds: {...inventory.ownedItemIds, item.id},
    );
    return PurchaseResult(wallet: nextWallet, inventory: nextInventory);
  }
}
