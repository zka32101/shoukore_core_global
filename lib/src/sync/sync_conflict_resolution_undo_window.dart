/// `OfflineSyncConflictResolver`が競合を解決した直後、一定時間内であれば
/// ユーザーが「元に戻す」操作を行えるべきかを判定する純関数。
/// `OfflineSyncConflictResolver`自体はどちらを採用するかの決定のみを行い、
/// 解決後に取り消しを許容する時間は見ない。`SyncConflictRecurrenceDetector`
/// は同一対象での再発検知のみを見るため、解決直後の取消許容時間は見ない。
/// 実際の取り消しUI・再マージ処理の実行はアプリ側の責務とする。
class SyncConflictResolutionUndoWindow {
  const SyncConflictResolutionUndoWindow({this.undoWindow = const Duration(minutes: 5)});

  /// 競合解決からこの時間内であれば取り消しを許可する。
  final Duration undoWindow;

  /// [resolvedAt]（競合解決が適用された時刻）から[now]までの経過が
  /// [undoWindow]以内であれば、取り消しを許可すべきと判定する。
  bool canUndo({required DateTime resolvedAt, required DateTime now}) {
    return now.difference(resolvedAt) <= undoWindow;
  }
}
