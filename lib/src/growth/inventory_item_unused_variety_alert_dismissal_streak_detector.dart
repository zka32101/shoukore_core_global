/// `InventoryItemUnusedVarietyAlert`による未使用アイテム種類数アラートが
/// 連続して無視され続けている状態を検知する純関数。
/// `InventoryItemUnusedVarietyAlert`自体は未使用アイテムの種類数のみを
/// 見る単発判定であり、出した後にユーザーがどう反応したかは見ない。
/// 実際の「まとめて使ってみよう」案内の表示方法の見直しはアプリ側の
/// 責務とする。
class InventoryItemUnusedVarietyAlertDismissalStreakDetector {
  const InventoryItemUnusedVarietyAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された未使用種類数
  /// アラートの回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
