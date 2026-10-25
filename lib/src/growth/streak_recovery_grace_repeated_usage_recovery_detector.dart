/// `StreakRecoveryGraceRepeatedUsageDetector`が検知した見逃し猶予の
/// 繰り返し利用パターンが解消し、連続して猶予に頼らず学習できるように
/// なったと判定され続けているかを判定する純関数。
/// `StreakRecoveryGraceRepeatedUsageDetector`自体は繰り返しパターンの
/// 有無のみを見る単発判定であり、解消の確認自体は見ない。実際の学習
/// 習慣の見直し案内の解除方法はアプリ側の責務とする。
class StreakRecoveryGraceRepeatedUsageRecoveryDetector {
  const StreakRecoveryGraceRepeatedUsageRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveNonGraceUsageCount]（直近から連続して見逃し猶予を
  /// 使わずに学習できた回数）が[recoveryThreshold]以上であれば、解消
  /// 状態と判定する。
  bool isRecovered(int consecutiveNonGraceUsageCount) {
    return consecutiveNonGraceUsageCount >= recoveryThreshold;
  }
}
