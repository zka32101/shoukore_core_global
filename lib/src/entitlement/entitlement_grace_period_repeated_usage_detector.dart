/// `EntitlementGracePeriod`による猶予期間が、課金サイクルごとに繰り返し
/// 使われている（毎回失効ギリギリまで更新されない）パターンを検知する
/// 純関数。`EntitlementGracePeriodEndingSoonReminder`は単発の猶予期間が
/// 終了間近であることのみを見るため、猶予期間の利用自体が繰り返されて
/// いるかは見ない。`EntitlementRestoreFailureStreak`は復元試行の連続失敗
/// のみを見る。実際の更新方法の見直し案内はアプリ側の責務とする。
class EntitlementGracePeriodRepeatedUsageDetector {
  const EntitlementGracePeriodRepeatedUsageDetector({this.repeatedUsageThreshold = 3});

  /// 連続してこの回数以上猶予期間が使われたら繰り返しパターンとみなす。
  final int repeatedUsageThreshold;

  /// [consecutiveGracePeriodUsageCount]（直近から連続して猶予期間が
  /// 使用された課金サイクルの回数）が[repeatedUsageThreshold]以上であれば
  /// 繰り返しパターンと判定する。
  bool isRepeatedlyUsed(int consecutiveGracePeriodUsageCount) {
    return consecutiveGracePeriodUsageCount >= repeatedUsageThreshold;
  }
}
