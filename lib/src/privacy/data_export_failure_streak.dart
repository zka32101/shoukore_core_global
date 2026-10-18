/// データエクスポートの試行が連続して失敗している状態を検知する純関数。
/// `DataExportRequestThrottle`は要求の間隔が短すぎないかの制限のみを
/// 行うため、要求自体が連続して失敗しているかどうかは見ない。実際の
/// エラー表示・サポート窓口への案内はアプリ側の責務とする。
class DataExportFailureStreak {
  const DataExportFailureStreak({this.failureThreshold = 3});

  /// 連続失敗がこの回数以上になったら検知対象とみなす。
  final int failureThreshold;

  /// [consecutiveFailureCount]（直近から連続して失敗したエクスポート
  /// 試行の回数）が[failureThreshold]以上であれば、連続失敗状態と判定する。
  bool isPersistentlyFailing(int consecutiveFailureCount) {
    return consecutiveFailureCount >= failureThreshold;
  }
}
