import 'pending_sync_item.dart';

/// `PendingSyncQueue`に積まれた[PendingSyncItem.retryCount]から、次回再送までの
/// 待機時間を指数バックオフで計算する純関数。実際のHTTP送信・APIコールは
/// アプリ側の責務とし、本クラスは「いつ再送してよいか」の計算のみを担う。
class RetryBackoffPolicy {
  const RetryBackoffPolicy({
    this.baseDelay = const Duration(seconds: 30),
    this.maxDelay = const Duration(hours: 1),
    this.maxAttempts = 8,
  }) : assert(maxAttempts > 0);

  /// 1回目の失敗後に待つ基準時間。
  final Duration baseDelay;

  /// バックオフの上限（これを超えて待機時間が伸びないようにする）。
  final Duration maxDelay;

  /// これ以上の失敗回数になったら再送を諦めるべきと判定する閾値。
  final int maxAttempts;

  /// [item]の失敗回数から次回再送までの待機時間を計算する
  /// （`baseDelay * 2^retryCount`、`maxDelay`で上限）。
  Duration nextDelay(PendingSyncItem item) {
    final multiplier = 1 << item.retryCount.clamp(0, 30);
    final delay = baseDelay * multiplier;
    return delay > maxDelay ? maxDelay : delay;
  }

  /// [item]を基準に[now]時点で再送してよいかどうかを判定する。
  bool shouldRetryNow(PendingSyncItem item, DateTime now) {
    if (hasExhaustedRetries(item)) return false;
    return now.isAfter(item.createdAt.add(nextDelay(item)));
  }

  /// [item]の失敗回数が[maxAttempts]に達し、再送を諦めるべきかどうかを判定する。
  bool hasExhaustedRetries(PendingSyncItem item) => item.retryCount >= maxAttempts;
}
