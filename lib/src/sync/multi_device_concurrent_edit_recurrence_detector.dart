/// `MultiDeviceConcurrentEditDetector`が複数デバイスからの同時編集の
/// 可能性を検知した結果が、単発ではなく同期のたびに繰り返し検出され
/// 続けているかを判定する純関数。`MultiDeviceConcurrentEditDetector`
/// 自体は直近1回分の更新ペアのみを見るため、繰り返しの発生自体は
/// 見ない。実際の競合解決・保護者への通知方法の見直しはアプリ側の
/// 責務とする。
class MultiDeviceConcurrentEditRecurrenceDetector {
  const MultiDeviceConcurrentEditRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上同時編集が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveConcurrentEditCount]（直近から連続して同時編集の
  /// 可能性が検出された回数）が[recurrenceThreshold]以上であれば、
  /// 繰り返し検出されている状態と判定する。
  bool isRecurring(int consecutiveConcurrentEditCount) {
    return consecutiveConcurrentEditCount >= recurrenceThreshold;
  }
}
