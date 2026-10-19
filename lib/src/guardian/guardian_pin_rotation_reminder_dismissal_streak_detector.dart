/// `GuardianPinRotationReminder`によるPINローテーション催促が連続して
/// 無視され続けている状態を検知する純関数。`GuardianPinRotationReminder`
/// 自体は催促すべきかどうかの単発判定のみを行い、出した後の反応は見ない。
/// `GuardianPinWeaknessDetector`・`GuardianPinReuseAfterRotationDetector`
/// はPINの値自体の強度・再利用を見るものであり、催促への反応は見ない。
/// 実際の表示方法の見直し案内はアプリ側の責務とする。
class GuardianPinRotationReminderDismissalStreakDetector {
  const GuardianPinRotationReminderDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視されたPINローテー
  /// ション催促の回数）が[dismissalThreshold]以上であれば、連続無視状態
  /// と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
