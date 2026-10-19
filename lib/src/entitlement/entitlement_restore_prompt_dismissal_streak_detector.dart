/// `EntitlementRestorePrompt`が復元を促しているにもかかわらず、連続して
/// 無視（閉じる）され続けている状態を検知する純関数。
/// `EntitlementRestoreFailureStreak`は復元処理そのものが技術的に失敗した
/// 回数のみを見るため、ユーザーがプロンプトを無視する行動は見ない。
/// `EntitlementRestoreStalenessNotice`は最後に復元を実行した時刻からの
/// 経過時間のみを見るため、無視が連続しているかは見ない。実際の表示
/// 頻度の調整・案内文の変更はアプリ側の責務とする。
class EntitlementRestorePromptDismissalStreakDetector {
  const EntitlementRestorePromptDismissalStreakDetector({
    this.dismissalThreshold = 3,
  });

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続してプロンプトを無視した
  /// 回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
