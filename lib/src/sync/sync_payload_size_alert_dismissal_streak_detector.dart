/// `SyncPayloadSizeAlert`による同期ペイロードサイズ異常アラートが連続
/// して無視され続けている状態を検知する純関数。`SyncPayloadSizeAlert`
/// 自体はペイロード1件分のバイト数のみを見る単発判定であり、出した後に
/// ユーザーがどう反応したかは見ない。実際のペイロード圧縮・送信抑制の
/// 見直しはアプリ側の責務とする。
class SyncPayloadSizeAlertDismissalStreakDetector {
  const SyncPayloadSizeAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された同期ペイ
  /// ロードサイズ異常アラートの回数）が[dismissalThreshold]以上であれ
  /// ば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
