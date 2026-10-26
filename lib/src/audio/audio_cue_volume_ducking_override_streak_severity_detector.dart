/// `AudioCueVolumeDuckingOverrideStreakDetector`が検知した連続オーバー
/// ライドパターンが、さらに深刻な域まで達しているかを判定する純関数。
/// `AudioCueVolumeDuckingOverrideStreakDetector`自体は閾値を超えたか
/// どうかの単発判定のみを見るため、どの程度深刻かは見ない。実際の
/// 案内の強さの切り分けはアプリ側の責務とする。
class AudioCueVolumeDuckingOverrideStreakSeverityDetector {
  const AudioCueVolumeDuckingOverrideStreakSeverityDetector({
    this.severeThreshold = 6,
  }) : assert(severeThreshold > 0);

  final int severeThreshold;

  /// [consecutiveOverrideCount]（直近から連続してダッキングが
  /// オーバーライドされた回数）が[severeThreshold]以上であれば、
  /// 深刻な状態と判定する。
  bool isSevere(int consecutiveOverrideCount) {
    return consecutiveOverrideCount >= severeThreshold;
  }
}
