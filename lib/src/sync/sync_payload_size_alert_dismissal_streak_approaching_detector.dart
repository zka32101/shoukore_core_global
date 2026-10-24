/// `SyncPayloadSizeAlertDismissalStreakDetector`が連続無視状態と
/// 判定する閾値にまだ到達していないが、あと少しで到達しそうな状態
/// を検知する純関数。
/// `SyncPayloadSizeAlertDismissalStreakDetector`自体は閾値到達後
/// のみを判定し、到達前の接近状態自体は見ない。実際のペイロード
/// 圧縮・送信抑制の見直しはアプリ側の責務とする。
class SyncPayloadSizeAlertDismissalStreakApproachingDetector {
  const SyncPayloadSizeAlertDismissalStreakApproachingDetector({
    this.marginRatio = 0.2,
  }) : assert(marginRatio > 0 && marginRatio < 1);

  /// 閾値に対してこの割合以内まで近づいていれば接近とみなす。
  final double marginRatio;

  /// [consecutiveDismissalCount]（直近から連続して無視された同期ペイ
  /// ロードサイズ異常アラートの回数）が[dismissalThreshold]未満かつ、
  /// [dismissalThreshold] * (1 - [marginRatio])以上であれば、接近状態
  /// と判定する。
  bool isApproaching({
    required int consecutiveDismissalCount,
    required int dismissalThreshold,
  }) {
    if (consecutiveDismissalCount >= dismissalThreshold) {
      return false;
    }
    final marginStart = (dismissalThreshold * (1 - marginRatio)).ceil();
    return consecutiveDismissalCount >= marginStart;
  }
}
