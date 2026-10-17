/// 同じ端末を共有する兄弟プロフィール間で、学習時間の配分が極端に
/// 偏っていないかを判定する純関数。`SiblingProfileSwitchSuggestion`
/// （操作が一定時間ないときに切替を促す）とは異なり、本クラスは
/// 累積の利用時間比率のみを見る。実際の保護者への報告・利用時間の
/// 調整提案はアプリ側の責務とする。
class SiblingProfileUsageBalance {
  const SiblingProfileUsageBalance({this.dominantShareThreshold = 0.8});

  /// 1人のプロフィールが全体の利用時間に占める割合がこれ以上であれば
  /// 偏りとみなす。
  final double dominantShareThreshold;

  /// [usageDurationsByProfileId]（プロフィールID→累積利用時間）のうち、
  /// 2件以上のプロフィールが存在し、最も利用時間が長いプロフィールの
  /// 割合が[dominantShareThreshold]以上であれば偏りありと判定する。
  bool isImbalanced(Map<String, Duration> usageDurationsByProfileId) {
    if (usageDurationsByProfileId.length < 2) return false;

    final total = usageDurationsByProfileId.values
        .fold<int>(0, (sum, d) => sum + d.inSeconds);
    if (total == 0) return false;

    final maxUsage = usageDurationsByProfileId.values
        .map((d) => d.inSeconds)
        .reduce((a, b) => a > b ? a : b);

    return maxUsage / total >= dominantShareThreshold;
  }
}
