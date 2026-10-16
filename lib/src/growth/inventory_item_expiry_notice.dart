/// 期間限定で所持しているアイテム（イベント配布アイテム等）が、消費期限
/// 切れ前に気づけるようにすべきかを判定する純関数。`InventorySnapshot`
/// 自体は所持アイテムIDの集合のみを保持し期限の概念を持たないため、
/// 本クラスがアプリ側が別途管理する「アイテムID→期限」の対応を受け取り、
/// 期限が近いものを抽出する。実際の通知表示・期限切れ後の失効処理は
/// アプリ側の責務とする。
class InventoryItemExpiryNotice {
  const InventoryItemExpiryNotice({this.noticeWindow = const Duration(days: 3)});

  /// 期限までこの期間を切ったら通知対象とする。
  final Duration noticeWindow;

  /// [expiresAtByItemId]（アイテムID→期限）のうち、[now]時点で期限切れ
  /// ではなく、かつ期限まで[noticeWindow]以内のアイテムIDを返す。
  List<String> itemsNearingExpiry({
    required Map<String, DateTime> expiresAtByItemId,
    required DateTime now,
  }) {
    return expiresAtByItemId.entries
        .where((entry) {
          final remaining = entry.value.difference(now);
          return !remaining.isNegative && remaining <= noticeWindow;
        })
        .map((entry) => entry.key)
        .toList();
  }
}
