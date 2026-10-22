/// `MasteryRapidDecayDetector`が習熟度の急激な減衰を検知した結果が、
/// 単発ではなく確認のたびに繰り返し検出され続けているかを判定する純
/// 関数。`MasteryRapidDecayDetector`自体は直近1回分の減衰量のみを見る
/// ため、繰り返しの発生自体は見ない。`MasteryDecayAccelerationDetector`
/// は減衰量そのものが悪化トレンドにあるかを見るものであり、急激な
/// 減衰判定が繰り返されているかとは異なる。実際の優先表示・通知の
/// 見直しはアプリ側の責務とする。
class MasteryRapidDecayRecurrenceDetector {
  const MasteryRapidDecayRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上急激な減衰が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveRapidDecayCount]（直近から連続して急激な減衰が検出
  /// された回数）が[recurrenceThreshold]以上であれば、繰り返し検出
  /// されている状態と判定する。
  bool isRecurring(int consecutiveRapidDecayCount) {
    return consecutiveRapidDecayCount >= recurrenceThreshold;
  }
}
