/// `QuestionHintOverrelianceDetector`がヒントへの過度な依存を検知した
/// 結果が、単発ではなく確認のたびに繰り返し検出され続けているかを判定
/// する純関数。`QuestionHintOverrelianceDetector`自体は直近の出題範囲
/// 1回分のみを見るため、繰り返しの発生自体は見ない。実際のヒント
/// 利用に関する案内の表示方法の見直しはアプリ側の責務とする。
class QuestionHintOverrelianceRecurrenceDetector {
  const QuestionHintOverrelianceRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上過度な依存が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveOverrelianceCount]（直近から連続してヒント過度依存と
  /// 判定された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveOverrelianceCount) {
    return consecutiveOverrelianceCount >= recurrenceThreshold;
  }
}
