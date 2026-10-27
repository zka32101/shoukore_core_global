/// 学習計画タスクが短時間に不自然な数だけ連続完了した場合に、
/// 保護者の確認を要求すべきかを判定する純関数。`GuardianGate`
/// （即時PINチャレンジ）や`GuardianApprovalRequestQueue`（非同期の
/// 承認申請）とは異なり、本クラスはタスク完了そのもののバースト
/// 検知のみを担う。実際の確認UI・承認フロー自体はアプリ側の責務
/// とする。
class GuardianTaskApprovalGate {
  const GuardianTaskApprovalGate({
    this.burstThreshold = 5,
    this.burstWindow = const Duration(minutes: 1),
  }) : assert(burstThreshold > 0);

  /// この期間内に完了したタスク数が[burstThreshold]以上であれば
  /// バースト完了とみなす。
  final Duration burstWindow;

  /// バースト完了とみなす最低完了件数。
  final int burstThreshold;

  /// [recentCompletionTimestamps]（直近のタスク完了時刻の一覧）の
  /// うち、[now]から[burstWindow]以内に完了した件数が
  /// [burstThreshold]以上であれば、保護者確認が必要と判定する。
  bool requiresApproval(
    List<DateTime> recentCompletionTimestamps,
    DateTime now,
  ) {
    final countWithinWindow = recentCompletionTimestamps
        .where((timestamp) => now.difference(timestamp) <= burstWindow)
        .length;
    return countWithinWindow >= burstThreshold;
  }
}
