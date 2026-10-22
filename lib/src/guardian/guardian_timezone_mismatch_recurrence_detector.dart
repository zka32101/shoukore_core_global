/// `GuardianTimezoneMismatchDetector`が子どもと保護者の端末のタイムゾーン
/// 不一致と判定した結果が、単発ではなく確認のたびに繰り返し検出され続け
/// ているかを判定する純関数。`GuardianTimezoneMismatchDetector`自体は
/// 直近1回分のオフセット差のみを見るため、繰り返しの発生自体は見ない。
/// 実際の時差補正案内の表示方法の見直しはアプリ側の責務とする。
class GuardianTimezoneMismatchRecurrenceDetector {
  const GuardianTimezoneMismatchRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上不一致が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveMismatchCount]（直近から連続してタイムゾーン不一致と
  /// 判定された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveMismatchCount) {
    return consecutiveMismatchCount >= recurrenceThreshold;
  }
}
