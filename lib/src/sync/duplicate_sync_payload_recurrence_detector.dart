/// `DuplicateSyncPayloadDetector`が同期キュー内の重複ペイロードを検知
/// した結果が、単発ではなく同期のたびに繰り返し検出され続けているかを
/// 判定する純関数。`DuplicateSyncPayloadDetector`自体は直近1回分の
/// キュー内容のみを見るため、繰り返しの発生自体は見ない。実際の
/// 重複除去・サーバー側への問い合わせ方法の見直しはアプリ側の責務と
/// する。
class DuplicateSyncPayloadRecurrenceDetector {
  const DuplicateSyncPayloadRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上重複が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveDuplicateCount]（直近から連続して重複ペイロードが
  /// 検出された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveDuplicateCount) {
    return consecutiveDuplicateCount >= recurrenceThreshold;
  }
}
