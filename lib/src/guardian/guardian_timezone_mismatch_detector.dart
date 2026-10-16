/// 子どもの端末と保護者の端末のタイムゾーンのUTCオフセットが大きく異なって
/// いないかを判定する純関数。`TimeZoneDriftDetector`（同一端末のタイムゾーン
/// が前回記録時と変わっていないかの検出）とは異なり、本クラスは子どもと
/// 保護者という異なる2台の端末間のオフセット差を見る。海外在住の保護者等、
/// 時差がある場合に「今日のミッション」等の通知が保護者側では深夜に届く
/// ような事態に気づけるようにする。実際の通知時刻の補正・表示はアプリ側の
/// 責務とする。
class GuardianTimezoneMismatchDetector {
  const GuardianTimezoneMismatchDetector({this.threshold = const Duration(hours: 1)});

  /// オフセット差がこれを超えたら不一致とみなす。
  final Duration threshold;

  /// [childUtcOffset]と[parentUtcOffset]の差の絶対値が[threshold]を超えて
  /// いれば不一致と判定する。
  bool hasMismatch({required Duration childUtcOffset, required Duration parentUtcOffset}) {
    return (childUtcOffset - parentUtcOffset).abs() > threshold;
  }
}
