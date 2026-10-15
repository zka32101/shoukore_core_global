/// `InventoryStore`が読み書きする永続化スナップショット。
/// 所持しているアイテムIDの集合のみを保持する。
class InventorySnapshot {
  const InventorySnapshot({this.ownedItemIds = const {}});

  static const initial = InventorySnapshot();

  final Set<String> ownedItemIds;

  bool owns(String itemId) => ownedItemIds.contains(itemId);
}
