/// `GrowthStageStallDetector`が成長段階の停滞を検知した結果が、単発
/// ではなく確認のたびに繰り返し検出され続けているかを判定する純関数。
/// `GrowthStageStallDetector`自体は直近1回分の比較のみを見るため、
/// 繰り返しの発生自体は見ない。実際の「学習を続けよう」案内の表示方法
/// の見直しはアプリ側の責務とする。
class GrowthStageStallRecurrenceDetector {
  const GrowthStageStallRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上停滞が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveStallCount]（直近から連続して成長段階の停滞が検出
  /// された回数）が[recurrenceThreshold]以上であれば、繰り返し検出
  /// されている状態と判定する。
  bool isRecurring(int consecutiveStallCount) {
    return consecutiveStallCount >= recurrenceThreshold;
  }
}
