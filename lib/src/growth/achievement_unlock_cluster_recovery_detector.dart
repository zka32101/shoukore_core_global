/// `AchievementUnlockClusterDetector`が検知した実績の同時解除の密集が
/// 解消し、連続して密集なしと判定され続けているかを判定する純関数。
/// `AchievementUnlockClusterDetector`自体は1回の評価での同時解除数の
/// みを見る単発判定であり、解消の確認自体は見ない。
/// `AchievementUnlockClusterRecurrenceDetector`は密集が繰り返されて
/// いるかを見るもので、本クラスはその逆軸（解消の確認）を見る。実際の
/// 祝賀表示の分散・順序付けの解除方法の見直しはアプリ側の責務とする。
class AchievementUnlockClusterRecoveryDetector {
  const AchievementUnlockClusterRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonClusterCount) {
    return consecutiveNonClusterCount >= recoveryThreshold;
  }
}
