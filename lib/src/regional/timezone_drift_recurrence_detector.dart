/// `TimeZoneDriftDetector`がタイムゾーンの変更を検知した結果が、単発
/// ではなく確認のたびに繰り返し検出され続けているかを判定する純関数。
/// `TimeZoneDriftDetector`自体は直近1回分の比較のみを見るため、繰り
/// 返しの発生自体は見ない。実際の再確認ダイアログの表示方法の見直しは
/// アプリ側の責務とする。
class TimeZoneDriftRecurrenceDetector {
  const TimeZoneDriftRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上変更が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveDriftCount]（直近から連続してタイムゾーンの変更が
  /// 検出された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveDriftCount) {
    return consecutiveDriftCount >= recurrenceThreshold;
  }
}
