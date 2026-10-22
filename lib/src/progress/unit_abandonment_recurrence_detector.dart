/// `UnitAbandonmentDetector`が単元の放置状態を検知した結果が、単発
/// ではなく確認のたびに（他の単元を含めて）繰り返し検出され続けている
/// かを判定する純関数。`UnitAbandonmentDetector`自体は単一単元1件分
/// のみを見るため、繰り返しの発生自体は見ない。実際の「もう一度やって
/// みよう」案内の表示方法の見直しはアプリ側の責務とする。
class UnitAbandonmentRecurrenceDetector {
  const UnitAbandonmentRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上放置が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveAbandonmentCount]（直近から連続して単元の放置が
  /// 検出された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveAbandonmentCount) {
    return consecutiveAbandonmentCount >= recurrenceThreshold;
  }
}
