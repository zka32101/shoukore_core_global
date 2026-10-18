/// 未使用のまま保持しているインベントリアイテムの「種類数」が一定数を
/// 超えている状態を検知する純関数。`InventoryItemStaleUsageNotice`は
/// 個々のアイテムの最終使用からの経過時間のみを見るため、未使用アイテムの
/// 種類がどれだけ多く積み上がっているかは見ない。`InventoryDuplicateGiftGuard`
/// はギフト付与時の重複防止のみを行い、本クラスとは目的が異なる。実際の
/// 「まとめて使ってみよう」案内の表示はアプリ側の責務とする。
class InventoryItemUnusedVarietyAlert {
  const InventoryItemUnusedVarietyAlert({this.unusedVarietyThreshold = 5})
      : assert(unusedVarietyThreshold > 0);

  /// 未使用アイテムの種類数がこの件数以上であればアラート対象と判定する。
  final int unusedVarietyThreshold;

  /// [lastUsedAtByItemId]（アイテムID→最終使用時刻、未使用は`null`）のうち、
  /// 一度も使用していないアイテムIDの一覧を返す。
  List<String> findUnusedItemIds(Map<String, DateTime?> lastUsedAtByItemId) {
    return lastUsedAtByItemId.entries
        .where((entry) => entry.value == null)
        .map((entry) => entry.key)
        .toList();
  }

  /// 未使用アイテムの種類数が[unusedVarietyThreshold]以上であればアラート
  /// すべきと判定する。
  bool shouldAlert(Map<String, DateTime?> lastUsedAtByItemId) {
    return findUnusedItemIds(lastUsedAtByItemId).length >= unusedVarietyThreshold;
  }
}
