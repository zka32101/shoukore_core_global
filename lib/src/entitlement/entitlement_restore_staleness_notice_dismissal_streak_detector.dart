/// `EntitlementRestoreStalenessNotice`による購入復元の長期未実行通知が
/// 連続して無視され続けている状態を検知する純関数。
/// `EntitlementRestoreStalenessNotice`自体は最後に復元を実行した時刻から
/// の経過時間のみを見る単発判定であり、出した後にユーザーがどう反応した
/// かは見ない。`EntitlementRestorePromptDismissalStreakDetector`は権利
/// 情報の食い違いを起因とする別の通知の連続無視を見るため、本クラスとは
/// 対象が異なる。実際の表示方法の見直し案内はアプリ側の責務とする。
class EntitlementRestoreStalenessNoticeDismissalStreakDetector {
  const EntitlementRestoreStalenessNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された復元長期未
  /// 実行通知の回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
