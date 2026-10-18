/// 同期待ちの複数アイテムのうち、リトライのバックオフ上限に達して再送を
/// 諦めた（`RetryBackoffPolicy.hasExhaustedRetries`が`true`を返す）件数の
/// 割合が高く、個別のアイテムの問題ではなくシステム的な同期障害である
/// 可能性を検知する純関数。`RetryBackoffPolicy`自体は単一アイテムが
/// バックオフ上限に達したかどうかの判定のみを行い、他のアイテムとの
/// 比較は見ないため、本クラスが全体に対する割合を見る。実際のサーバー
/// 状態の確認・メンテナンス通知の表示はアプリ側の責務とする。
class RetryBackoffExhaustionRateAlert {
  const RetryBackoffExhaustionRateAlert({this.exhaustionRateThreshold = 0.5});

  /// 枯渇件数の割合がこの値以上であれば、システム的な障害とみなす。
  final double exhaustionRateThreshold;

  /// [totalPendingCount]（同期待ちの総件数）に対する[exhaustedCount]
  /// （バックオフ上限に達した件数）の割合が[exhaustionRateThreshold]以上
  /// であれば、システム的な同期障害の可能性があると判定する。
  /// [totalPendingCount]が0の場合は`false`を返す。
  bool isSystemicFailure({required int exhaustedCount, required int totalPendingCount}) {
    if (totalPendingCount == 0) return false;
    return exhaustedCount / totalPendingCount >= exhaustionRateThreshold;
  }
}
