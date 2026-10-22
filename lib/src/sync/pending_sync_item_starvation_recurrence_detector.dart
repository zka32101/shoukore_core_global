/// `PendingSyncItemStarvationDetector`が同期待ちアイテムのスタベー
/// ションを検知した結果が、単発ではなく確認のたびに繰り返し検出され
/// 続けているかを判定する純関数。`PendingSyncItemStarvationDetector`
/// 自体は直近1回分のキュー状態のみを見るため、繰り返しの発生自体は
/// 見ない。実際の優先送信・個別リトライの見直しはアプリ側の責務と
/// する。
class PendingSyncItemStarvationRecurrenceDetector {
  const PendingSyncItemStarvationRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上スタベーションが検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveStarvationCount]（直近から連続してスタベーション状態
  /// のアイテムが検出された回数）が[recurrenceThreshold]以上であれば、
  /// 繰り返し検出されている状態と判定する。
  bool isRecurring(int consecutiveStarvationCount) {
    return consecutiveStarvationCount >= recurrenceThreshold;
  }
}
