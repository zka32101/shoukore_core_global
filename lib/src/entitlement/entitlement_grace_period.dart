/// サブスクリプション失効後、一定期間だけ機能利用を継続させる猶予期間を
/// 判定する純関数。オフライン環境で課金ストアへの再確認ができない場合等に、
/// 体験を損なわないための猶予を計算するだけで、価格・プラン自体のロジックは
/// `EntitlementReader`（アプリ側のRevenueCat等実装）の責務とする。
class EntitlementGracePeriod {
  const EntitlementGracePeriod({this.graceDuration = const Duration(days: 3)});

  /// 失効時刻からこの期間内であれば、引き続き利用可能とみなす。
  final Duration graceDuration;

  /// [expiredAt]（課金の失効時刻）から[now]までの経過が[graceDuration]以内
  /// であれば、猶予期間中として`true`を返す。
  bool isWithinGrace({required DateTime expiredAt, required DateTime now}) {
    return now.difference(expiredAt) <= graceDuration;
  }

  /// 猶予期間が終了する時刻。
  DateTime graceEndsAt(DateTime expiredAt) => expiredAt.add(graceDuration);
}
