/// `UnitRecommendationIgnoredDetector`が検知した単元提案の無視状態が
/// 解消し、連続して着手されていると判定され続けているかを判定する
/// 純関数。`UnitRecommendationIgnoredDetector`自体は1回の提示回数のみ
/// を見る単発判定であり、解消の確認自体は見ない。実際の提案内容の
/// 変更・別単元への切り替えの解除方法の見直しはアプリ側の責務とする。
class UnitRecommendationIgnoredRecoveryDetector {
  const UnitRecommendationIgnoredRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonIgnoredCount) {
    return consecutiveNonIgnoredCount >= recoveryThreshold;
  }
}
