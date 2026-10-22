/// `GuardianApprovalRequestDuplicateDetector`が承認待ち申請の重複を
/// 検知した結果が、単発ではなく確認のたびに繰り返し検出され続けている
/// かを判定する純関数。`GuardianApprovalRequestDuplicateDetector`
/// 自体は直近1回分の申請一覧のみを見るため、繰り返しの発生自体は
/// 見ない。実際の重複申請の統合・再送抑制の見直しはアプリ側の責務と
/// する。
class GuardianApprovalRequestDuplicateRecurrenceDetector {
  const GuardianApprovalRequestDuplicateRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上重複が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveDuplicateCount]（直近から連続して承認待ち申請の重複が
  /// 検出された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveDuplicateCount) {
    return consecutiveDuplicateCount >= recurrenceThreshold;
  }
}
