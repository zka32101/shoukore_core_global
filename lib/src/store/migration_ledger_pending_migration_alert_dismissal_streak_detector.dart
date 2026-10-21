/// `MigrationLedgerPendingMigrationAlert`による未適用マイグレーション
/// アラートが連続して無視され続けている状態を検知する純関数。
/// `MigrationLedgerPendingMigrationAlert`自体は未適用マイグレーションの
/// 有無のみを見る単発判定であり、出した後にユーザーがどう反応したかは
/// 見ない。実際の再実行・強制案内の表示方法の見直しはアプリ側の責務と
/// する。
class MigrationLedgerPendingMigrationAlertDismissalStreakDetector {
  const MigrationLedgerPendingMigrationAlertDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された未適用
  /// マイグレーションアラートの回数）が[dismissalThreshold]以上であれば、
  /// 連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
