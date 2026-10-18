import '../clock/clock.dart';
import 'pending_sync_item.dart';

/// 同期待ちキュー内で、他のアイテムに比べて著しく長く待たされている個別の
/// アイテム（スタベーション）を検知する純関数。`SyncQueueBacklogAlert`は
/// キュー全体の件数の積み上がりのみを見るため、特定のアイテムだけが
/// 取り残されているという偏りは見ない。実際の優先送信・個別リトライの
/// 実行はアプリ側の責務とする。
class PendingSyncItemStarvationDetector {
  const PendingSyncItemStarvationDetector({
    required this.clock,
    this.starvationThreshold = const Duration(hours: 1),
  });

  final Clock clock;

  /// 作成からこの時間以上経過していれば、スタベーション対象とみなす。
  final Duration starvationThreshold;

  /// [pendingItems]のうち、[starvationThreshold]以上待たされているアイテムを返す。
  List<PendingSyncItem> starvedItems(List<PendingSyncItem> pendingItems) {
    final now = clock.now();
    return pendingItems
        .where((item) => now.difference(item.createdAt) >= starvationThreshold)
        .toList();
  }

  /// スタベーション状態のアイテムが1件以上存在するかを判定する。
  bool hasStarvedItem(List<PendingSyncItem> pendingItems) {
    return starvedItems(pendingItems).isNotEmpty;
  }
}
