/// `SettingsBackupStalenessNotice`による設定バックアップの催促が連続して
/// 無視され続けている状態を検知する純関数。`SettingsBackupStalenessNotice`
/// 自体は催促すべきかどうかの単発判定のみを行い、出した後にユーザーが
/// どう反応したかは見ない。実際の表示方法の見直し案内はアプリ側の責務
/// とする。
class SettingsBackupStalenessNoticeDismissalStreakDetector {
  const SettingsBackupStalenessNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された催促の回数）
  /// が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
