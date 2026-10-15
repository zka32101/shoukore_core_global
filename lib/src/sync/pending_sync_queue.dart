import 'pending_sync_item.dart';

/// 送信失敗した学習記録等を溜めて再送するキューを抽象化する。
/// 実際の送信（HTTP等）・サーバー側APIはアプリ側の責務とし、本コアは
/// 「送信待ちのアイテムを永続化し、再送・成功・失敗を管理する」ことのみ提供する。
/// 既定実装は端末内drift(SQLite)。
abstract class PendingSyncQueue {
  /// 新しい送信待ちアイテムを追加する。
  Future<void> enqueue(PendingSyncItem item);

  /// 現在の送信待ちアイテムを古い順に返す。
  Future<List<PendingSyncItem>> listPending();

  /// 送信に成功したアイテムをキューから取り除く。
  Future<void> markSynced(String id);

  /// 送信に失敗したアイテムの再試行回数を+1する（キューには残る）。
  Future<void> markFailed(String id);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて全件消去する。
  Future<void> clearAll();
}
