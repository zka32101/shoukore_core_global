/// `UnitMasteryBadgeMotivationDropNotice`による単元マスター直後の学習
/// 意欲低下通知が連続して無視され続けている状態を検知する純関数。
/// `UnitMasteryBadgeMotivationDropNotice`自体はマスター達成後の経過時間
/// のみを見る単発判定であり、出した後にユーザーがどう反応したかは見ない。
/// 実際の表示方法の見直し案内はアプリ側の責務とする。
class UnitMasteryBadgeMotivationDropNoticeDismissalStreakDetector {
  const UnitMasteryBadgeMotivationDropNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された意欲低下通知の
  /// 回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
