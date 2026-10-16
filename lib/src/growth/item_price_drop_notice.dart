import 'store_item.dart';

/// 過去に見たアイテムの価格を記録する最小限の状態。
class SeenItemPrice {
  const SeenItemPrice({required this.itemId, required this.priceCoins});

  final String itemId;
  final int priceCoins;
}

/// ストアアイテムの価格が前回見た時点より下がっている場合、お得感を伝える
/// 通知を出すべきかを判定する純関数。価格自体の決定・セール運用ロジックは
/// アプリ側の責務とし、本コアは渡された[StoreItem.priceCoins]と
/// [SeenItemPrice]の単純比較のみを行う。`InventoryManager`の購入判定には
/// 関与しない。
class ItemPriceDropNotice {
  const ItemPriceDropNotice();

  /// [item]の現在価格が[lastSeen]（同じアイテムの前回記録価格）より
  /// 下がっていれば、通知すべきと判定する。[lastSeen]が`null`、または
  /// アイテムIDが一致しない場合は判定しない（`false`）。
  bool shouldNotify({required StoreItem item, required SeenItemPrice? lastSeen}) {
    if (lastSeen == null || lastSeen.itemId != item.id) return false;
    return item.priceCoins < lastSeen.priceCoins;
  }
}
