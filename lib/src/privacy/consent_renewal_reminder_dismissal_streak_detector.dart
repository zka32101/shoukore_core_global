/// `ConsentRenewalReminder`が出した再同意リマインドが連続して無視され
/// 続けている状態を検知する純関数。`ConsentRenewalReminder`自体はリマ
/// インドを出すべきかどうかの判定のみを行い、出した後にユーザーがどう
/// 反応したかは見ない。実際の表示方法の見直し・保護者への別経路での
/// 案内はアプリ側の責務とする。
class ConsentRenewalReminderDismissalStreakDetector {
  const ConsentRenewalReminderDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視されたリマインド
  /// の回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
