/// サーバー同期に送信する1件分のペイロードと送信状況。
/// ペイロードの形式（学習記録かconsentか等）はアプリ側が決める任意のMapとし、
/// 本コアは送信キュー自体の管理（再送・失敗回数）のみを担う。
class PendingSyncItem {
  const PendingSyncItem({
    required this.id,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  final String id;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;

  PendingSyncItem withRetryIncremented() => PendingSyncItem(
        id: id,
        payload: payload,
        createdAt: createdAt,
        retryCount: retryCount + 1,
      );
}
