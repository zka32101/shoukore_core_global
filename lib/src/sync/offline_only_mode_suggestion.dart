import 'pending_sync_item.dart';
import 'retry_backoff_policy.dart';

/// `RetryBackoffPolicy.hasExhaustedRetries`で再送を諦めるべきと判定された
/// アイテムが一定数以上溜まっている場合、同期を諦めてオフライン専用モード
/// への切り替えを提案すべきかを判定する純関数。`RetryBackoffPolicy`自体は
/// 1件ごとの再送可否のみを判定するため、本クラスがキュー全体を見て
/// 複数件が諦め状態にあるかを判定する。実際のモード切り替えUI・保護者への
/// 通知はアプリ側の責務とする。
class OfflineOnlyModeSuggestion {
  const OfflineOnlyModeSuggestion({
    this.minimumExhaustedCount = 3,
    RetryBackoffPolicy? retryBackoffPolicy,
  }) : retryBackoffPolicy = retryBackoffPolicy ?? const RetryBackoffPolicy();

  /// 再送を諦めたアイテムがこの件数以上溜まったら提案すべきと判定する。
  final int minimumExhaustedCount;

  final RetryBackoffPolicy retryBackoffPolicy;

  /// [items]のうち[RetryBackoffPolicy.hasExhaustedRetries]が`true`の件数が
  /// [minimumExhaustedCount]以上であれば、オフライン専用モードへの切り替え
  /// を提案すべきと判定する。
  bool shouldSuggest(List<PendingSyncItem> items) {
    final exhaustedCount =
        items.where((item) => retryBackoffPolicy.hasExhaustedRetries(item)).length;
    return exhaustedCount >= minimumExhaustedCount;
  }
}
