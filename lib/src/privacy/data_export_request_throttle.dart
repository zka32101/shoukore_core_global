/// データ書き出し要求（`exportUserData`、LGPD第18条等の権利行使対応）が
/// 短期間に繰り返されるのを防ぐための純関数。大量データの書き出しは
/// 端末・サーバー双方に負荷がかかるため、直前の要求からの間隔が短ければ
/// 次の要求を遅延させるべきと判定するだけで、実際の書き出し処理の呼び出し
/// 制御・UI表示はアプリ側の責務とする。
class DataExportRequestThrottle {
  const DataExportRequestThrottle({this.minInterval = const Duration(hours: 24)});

  /// 要求間に空けるべき最小間隔。
  final Duration minInterval;

  /// [lastRequestedAt]（直前の書き出し要求時刻）から[now]までの間隔が
  /// [minInterval]未満であれば、今回の要求を遅延させるべきと判定する。
  /// 一度も要求していない場合（`null`）は常に許可する。
  bool shouldThrottle({required DateTime? lastRequestedAt, required DateTime now}) {
    if (lastRequestedAt == null) return false;
    return now.difference(lastRequestedAt) < minInterval;
  }

  /// 次に要求が許可される時刻。[lastRequestedAt]が`null`の場合は即時許可。
  DateTime? nextAllowedAt(DateTime? lastRequestedAt) {
    if (lastRequestedAt == null) return null;
    return lastRequestedAt.add(minInterval);
  }
}
