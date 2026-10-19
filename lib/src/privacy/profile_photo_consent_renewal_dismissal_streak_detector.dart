/// `ProfilePhotoConsentRenewalNotice`による写真利用同意の再確認が連続して
/// 無視され続けている状態を検知する純関数。`ProfilePhotoConsentRenewalNotice`
/// 自体は再確認すべきかどうかの単発判定のみを行い、出した後にユーザーが
/// どう反応したかは見ない。`ConsentRenewalReminderDismissalStreakDetector`
/// は一般的な同意再同意リマインドへの無視を見るものであり、写真利用
/// 同意の再確認とは別物である。実際の表示方法の見直し案内はアプリ側の
/// 責務とする。
class ProfilePhotoConsentRenewalDismissalStreakDetector {
  const ProfilePhotoConsentRenewalDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された写真利用
  /// 同意の再確認回数）が[dismissalThreshold]以上であれば、連続無視状態
  /// と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
