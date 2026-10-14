/// ローカル通知のスケジューリングを抽象化する。プッシュ(FCM等)は対象外。
abstract class NotificationScheduler {
  /// `titleKey`/`bodyKey` は arb のキー。文言は呼び出し側(アプリ)がロケールに応じて解決する。
  Future<void> schedule({
    required String id,
    required DateTime at,
    required String titleKey,
    required String bodyKey,
  });

  Future<void> cancel(String id);

  Future<void> cancelAll();
}
