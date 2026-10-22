/// `PendingSyncItemStarvationDetector`が検知した同期待ちアイテムの
/// スタベーションが解消し、連続してスタベーションなしと判定され続けて
/// いるかを判定する純関数。`PendingSyncItemStarvationDetector`自体は
/// 直近1回分のキュー状態のみを見る単発判定であり、解消の確認自体は
/// 見ない。`PendingSyncItemStarvationRecurrenceDetector`はスタベーション
/// が繰り返されているかを見るもので、本クラスはその逆軸（解消の確認）
/// を見る。実際の優先送信・個別リトライの解除方法の見直しはアプリ側の
/// 責務とする。
class PendingSyncItemStarvationRecoveryDetector {
  const PendingSyncItemStarvationRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonStarvationCount) {
    return consecutiveNonStarvationCount >= recoveryThreshold;
  }
}
