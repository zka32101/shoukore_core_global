/// `ProgressStore`/`GrowthStore`等のローカルデータが最後にサーバーへ同期された
/// 時刻から一定期間を超えている場合に「要同期（stale）」と判定する純関数。
/// 最終同期時刻の記録・保存自体はアプリ側の責務とし、本クラスは判定のみを行う。
class StaleDataPolicy {
  const StaleDataPolicy({this.staleAfter = const Duration(days: 14)});

  /// 最終同期からこの期間を超えると「要同期」と判定する。
  final Duration staleAfter;

  /// [lastSyncedAt]が`null`（一度も同期されていない）、または[now]との差が
  /// [staleAfter]を超えている場合に`true`を返す。
  bool isStale(DateTime? lastSyncedAt, DateTime now) {
    if (lastSyncedAt == null) return true;
    return now.difference(lastSyncedAt) > staleAfter;
  }

  /// [lastSyncedAt]から要同期になるまでの残り時間を返す。既に要同期の場合は
  /// [Duration.zero]を返す。
  Duration remainingUntilStale(DateTime? lastSyncedAt, DateTime now) {
    if (isStale(lastSyncedAt, now)) return Duration.zero;
    final deadline = lastSyncedAt!.add(staleAfter);
    return deadline.difference(now);
  }
}
