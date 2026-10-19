/// `OfflineSessionGapDetector`が長時間オフラインと判定した後、再接続して
/// 同期待ちアイテムが全て送信済みになった時点で、オフライン中の学習内容が
/// 正しく反映されたことを案内すべきかを判定する純関数。
/// `OfflineSessionGapDetector`自体はギャップの長さのみを見て、同期完了後
/// の案内は見ない。実際の「同期が完了しました」表示はアプリ側の責務と
/// する。
class OfflineSessionResumeNotice {
  const OfflineSessionResumeNotice();

  /// [wasLongGap]（`OfflineSessionGapDetector.isLongGap`の結果）が`true`
  /// であり、かつ[pendingSyncCount]（現在の同期待ち件数）が0であれば、
  /// 同期完了を案内すべきと判定する。
  bool shouldNotify({required bool wasLongGap, required int pendingSyncCount}) {
    return wasLongGap && pendingSyncCount == 0;
  }
}
