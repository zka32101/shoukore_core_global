/// `importSettingsBackup`による設定バックアップの復元が連続して失敗
/// している状態を検知する純関数。`SettingsBackupStalenessNotice`は
/// 最後にバックアップを作成した時刻からの経過時間のみを見るため、
/// 復元操作自体の成否は見ない。`DataExportFailureStreak`は学習記録の
/// エクスポート失敗のみを見るため、設定バックアップの復元は見ない。
/// 実際のエラー表示・サポート窓口への案内はアプリ側の責務とする。
class SettingsBackupRestoreFailureStreak {
  const SettingsBackupRestoreFailureStreak({this.failureThreshold = 3})
      : assert(failureThreshold > 0);

  /// 連続失敗がこの回数以上になったら検知対象とみなす。
  final int failureThreshold;

  /// [consecutiveFailureCount]（直近から連続して失敗した復元試行の回数）
  /// が[failureThreshold]以上であれば、連続失敗状態と判定する。
  bool isPersistentlyFailing(int consecutiveFailureCount) {
    return consecutiveFailureCount >= failureThreshold;
  }
}
