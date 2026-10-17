/// 季節イベント（期間限定ミッション等）の開始/終了判定が、端末時刻の
/// タイムゾーンズレによって誤判定（早期終了・延長表示）されていないかを
/// 検証する純関数。`TimeZoneDriftDetector`はタイムゾーンの変化そのものの
/// 検出のみを行うため、本クラスはその結果（ズレの有無）を使って、イベント
/// 終了判定が信頼できる状態かを判定する。実際のイベント期間データの保持・
/// 再確認時のサーバー時刻取得はアプリ側の責務とする。
class SeasonalEventValidityGuard {
  const SeasonalEventValidityGuard({this.gracePeriod = const Duration(hours: 1)});

  /// イベント終了時刻からこの範囲内であれば、タイムゾーンズレの影響を
  /// 受けやすい「境界付近」とみなす。
  final Duration gracePeriod;

  /// [now]が[startAt]以上[endAt]以下であれば、イベント期間内と判定する。
  bool isWithinEventPeriod({
    required DateTime startAt,
    required DateTime endAt,
    required DateTime now,
  }) {
    return !now.isBefore(startAt) && !now.isAfter(endAt);
  }

  /// [hasTimeZoneDrifted]（`TimeZoneDriftDetector.hasDrifted`の結果）が
  /// `true`で、かつ[now]が[endAt]の[gracePeriod]以内（前後どちらか）に
  /// あれば、端末時刻のズレによる誤判定の可能性があるため、サーバー時刻
  /// 等での再確認を提案すべきと判定する。
  bool shouldRevalidateWithServerTime({
    required bool hasTimeZoneDrifted,
    required DateTime endAt,
    required DateTime now,
  }) {
    if (!hasTimeZoneDrifted) return false;
    return now.difference(endAt).abs() <= gracePeriod;
  }
}
