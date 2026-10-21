/// `InventoryItemStaleUsageNotice`による未使用アイテムの「使ってみよう」
/// 案内が連続して無視され続けている状態を検知する純関数。
/// `InventoryItemStaleUsageNotice`自体は最終使用からの経過時間のみを見る
/// 単発判定であり、出した後にユーザーがどう反応したかは見ない。実際の
/// 表示方法の見直し案内はアプリ側の責務とする。
class InventoryItemStaleUsageNoticeDismissalStreakDetector {
  const InventoryItemStaleUsageNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された未使用案内の
  /// 回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
