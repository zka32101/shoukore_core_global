import 'pending_sync_item.dart';

/// `PendingSyncQueue`に未送信アイテムが一定件数以上溜まっている場合、
/// 同期不調のアラートを出すべきかを判定する純関数。`RetryBackoffPolicy`
/// （個々のアイテムの再送タイミング）とは別に、キュー全体の滞留を検知
/// するだけで、実際のアラート表示・ユーザーへの通知はアプリ側の責務
/// とする。
class SyncQueueBacklogAlert {
  const SyncQueueBacklogAlert({this.backlogThreshold = 50}) : assert(backlogThreshold > 0);

  /// 未送信アイテムがこの件数以上溜まったらアラート対象と判定する。
  final int backlogThreshold;

  /// [pendingItems]の件数が[backlogThreshold]以上であればアラートすべきと
  /// 判定する。
  bool shouldAlert(List<PendingSyncItem> pendingItems) {
    return pendingItems.length >= backlogThreshold;
  }
}
