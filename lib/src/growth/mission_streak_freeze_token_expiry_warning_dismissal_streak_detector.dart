/// `MissionStreakFreezeTokenExpiryWarning`によるストリークフリーズ
/// トークンの失効間近警告が連続して無視され続けている状態を検知する
/// 純関数。`MissionStreakFreezeTokenExpiryWarning`自体は失効間近かどうか
/// の単発判定のみを行い、出した後にユーザーがどう反応したかは見ない。
/// `StreakFreezeTokenWasteDetector`は期限切れ後の未使用失効回数のみを
/// 見るため、失効前の事前警告への反応は見ない。実際の表示方法の見直し
/// 案内はアプリ側の責務とする。
class MissionStreakFreezeTokenExpiryWarningDismissalStreakDetector {
  const MissionStreakFreezeTokenExpiryWarningDismissalStreakDetector({
    this.dismissalThreshold = 3,
  }) : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された失効間近
  /// 警告の回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
