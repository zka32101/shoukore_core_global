import 'inventory_snapshot.dart';

/// キャンペーン等でアイテムをギフトとして付与する際、既に所持している
/// アイテムを重複して付与しないよう判定する純関数。`InventoryManager`
/// （コイン購入経路の重複チェック）とは別に、購入を伴わないギフト付与
/// 経路にも同じ考え方を適用する。実際のギフト付与処理・付与結果の通知は
/// アプリ側の責務とする。
class InventoryDuplicateGiftGuard {
  const InventoryDuplicateGiftGuard();

  /// [inventory]が[itemId]を既に所持していれば、ギフト付与を抑制すべきと
  /// 判定する。
  bool shouldBlockGift({required InventorySnapshot inventory, required String itemId}) {
    return inventory.owns(itemId);
  }
}
