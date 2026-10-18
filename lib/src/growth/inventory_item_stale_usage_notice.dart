/// 入手済みのインベントリアイテムが長期間使用されていない状態を検知する
/// 純関数。`InventoryItemExpiryNotice`は期限切れ前に気づけるようにする
/// 判定のみを行い、期限のないアイテムの使用頻度は見ないため、本クラスが
/// アプリ側から渡される最終使用時刻を見てその未使用期間を判定する。
/// 実際の「使ってみよう」案内の表示はアプリ側の責務とする。
class InventoryItemStaleUsageNotice {
  const InventoryItemStaleUsageNotice({this.staleAfter = const Duration(days: 14)});

  /// 最終使用からこの期間を超えたら未使用とみなす。
  final Duration staleAfter;

  /// [lastUsedAtByItemId]（アイテムID→最終使用時刻、未使用は`null`）の
  /// うち、[now]との差が[staleAfter]以上、または一度も使用していない
  /// アイテムIDを返す。
  List<String> findStaleItemIds({
    required Map<String, DateTime?> lastUsedAtByItemId,
    required DateTime now,
  }) {
    return lastUsedAtByItemId.entries
        .where((entry) {
          final lastUsedAt = entry.value;
          if (lastUsedAt == null) return true;
          return now.difference(lastUsedAt) >= staleAfter;
        })
        .map((entry) => entry.key)
        .toList();
  }
}
