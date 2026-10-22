/// `GuardianGateRapidAttemptDetector`が保護者ゲートへの異常に速い連続
/// 試行を検知した結果が、単発ではなく確認のたびに繰り返し検出され続け
/// ているかを判定する純関数。`GuardianGateRapidAttemptDetector`自体は
/// 直前1回分の試行間隔のみを見るため、繰り返しの発生自体は見ない。
/// 実際の追加ロック・保護者への通知方法の見直しはアプリ側の責務と
/// する。
class GuardianGateRapidAttemptRecurrenceDetector {
  const GuardianGateRapidAttemptRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上異常な速さが検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveSuspiciousCount]（直近から連続して異常に速い試行間隔
  /// が検出された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveSuspiciousCount) {
    return consecutiveSuspiciousCount >= recurrenceThreshold;
  }
}
