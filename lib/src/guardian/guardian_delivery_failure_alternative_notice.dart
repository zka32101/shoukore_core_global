/// 保護者向け通知（ダイジェスト等）の配信が連続して失敗している場合に、
/// 通知方法そのものの見直しを提案すべきかを判定する純関数。
/// `WeeklyReportEngagementDeclineNotice`（既読率が継続して低い＝届いているが
/// 読まれない状態）とは異なり、本クラスは配信自体が届いていない
/// （配信エラー）状態のみを見る。実際の代替通知手段の提示・配信エラーの
/// 記録はアプリ側の責務とする。
class GuardianDeliveryFailureAlternativeNotice {
  const GuardianDeliveryFailureAlternativeNotice({this.consecutiveFailureThreshold = 3});

  /// 連続して配信に失敗した回数がこの値以上であれば、代替通知手段を
  /// 提案すべきと判定する。
  final int consecutiveFailureThreshold;

  /// [wasDeliveredNewestFirst]（直近の配信試行から新しい順の配信成功
  /// フラグ列）の先頭から数えて連続して配信失敗（`false`）している回数が
  /// [consecutiveFailureThreshold]以上であれば、代替通知手段を提案すべきと
  /// 判定する。
  bool shouldSuggestAlternativeChannel(List<bool> wasDeliveredNewestFirst) {
    var consecutiveFailures = 0;
    for (final wasDelivered in wasDeliveredNewestFirst) {
      if (wasDelivered) break;
      consecutiveFailures++;
    }
    return consecutiveFailures >= consecutiveFailureThreshold;
  }
}
