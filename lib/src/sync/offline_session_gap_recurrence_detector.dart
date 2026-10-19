/// `OfflineSessionGapDetector`が長時間オフラインギャップと判定した起動が
/// 単発ではなく習慣的に繰り返されているかを判定する純関数。
/// `OfflineSessionGapDetector`自体は直前の起動間隔1件のみを見るため、
/// 繰り返しの発生自体は見ない。実際の「オフライン学習の案内」等の表示
/// はアプリ側の責務とする。
class OfflineSessionGapRecurrenceDetector {
  const OfflineSessionGapRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上長時間ギャップが発生したら習慣的とみなす。
  final int recurrenceThreshold;

  /// [consecutiveLongGapCount]（直近から連続して長時間オフラインギャップ
  /// と判定された起動の回数）が[recurrenceThreshold]以上であれば、
  /// 習慣的な繰り返しと判定する。
  bool isRecurring(int consecutiveLongGapCount) {
    return consecutiveLongGapCount >= recurrenceThreshold;
  }
}
