/// 購入復元（リストア）の試行が連続して失敗している状態を検知する
/// 純関数。`EntitlementRestoreStalenessNotice`は最後に復元を実行した
/// 時刻からの経過時間のみを見るため、実行自体はされていても失敗が
/// 連続しているかどうかは見ない。実際のエラー表示・サポート窓口への
/// 案内はアプリ側の責務とする。
class EntitlementRestoreFailureStreak {
  const EntitlementRestoreFailureStreak({this.failureThreshold = 3});

  /// 連続失敗がこの回数以上になったら検知対象とみなす。
  final int failureThreshold;

  /// [consecutiveFailureCount]（直近から連続して失敗した復元試行の回数）
  /// が[failureThreshold]以上であれば、連続失敗状態と判定する。
  bool isPersistentlyFailing(int consecutiveFailureCount) {
    return consecutiveFailureCount >= failureThreshold;
  }
}
