/// `ConsentAuditLogGapDetector`が同意履歴の記録空白を検知した結果が、
/// 単発ではなく確認のたびに繰り返し検出され続けているかを判定する純
/// 関数。`ConsentAuditLogGapDetector`自体は直近1回分の履歴のみを見る
/// ため、繰り返しの発生自体は見ない。実際の同意状態の再確認案内の表示
/// 方法の見直しはアプリ側の責務とする。
class ConsentAuditLogGapRecurrenceDetector {
  const ConsentAuditLogGapRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上空白が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveGapCount]（直近から連続して同意履歴の記録空白が検出
  /// された回数）が[recurrenceThreshold]以上であれば、繰り返し検出
  /// されている状態と判定する。
  bool isRecurring(int consecutiveGapCount) {
    return consecutiveGapCount >= recurrenceThreshold;
  }
}
