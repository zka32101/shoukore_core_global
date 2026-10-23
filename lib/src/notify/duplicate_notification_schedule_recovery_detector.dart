/// `DuplicateNotificationScheduleDetector`が検知した同一内容の通知の
/// 重複予約が解消し、連続して重複なしと判定され続けているかを判定する
/// 純関数。`DuplicateNotificationScheduleDetector`自体は1件の候補に
/// ついての単発判定であり、解消の確認自体は見ない。
/// `DuplicateNotificationScheduleRecurrenceDetector`は重複が繰り返
/// されているかを見るもので、本クラスはその逆軸（解消の確認）を見る。
/// 実際の重複通知のキャンセル・統合処理の解除方法の見直しはアプリ側
/// の責務とする。
class DuplicateNotificationScheduleRecoveryDetector {
  const DuplicateNotificationScheduleRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonDuplicateCount) {
    return consecutiveNonDuplicateCount >= recoveryThreshold;
  }
}
