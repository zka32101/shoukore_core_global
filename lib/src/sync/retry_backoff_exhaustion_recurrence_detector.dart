/// `RetryBackoffExhaustionRateAlert`がシステム的な同期障害と判定した
/// 状態が、単発ではなく複数回連続して発生しているかを判定する純関数。
/// `RetryBackoffExhaustionRateAlert`自体は1回の判定時点での枯渇件数の
/// 割合のみを見るため、その判定が繰り返し続いているかは見ない。実際の
/// サーバー状態の確認・メンテナンス通知の表示はアプリ側の責務とする。
class RetryBackoffExhaustionRecurrenceDetector {
  const RetryBackoffExhaustionRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上システム的障害と判定されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveSystemicFailureCount]（直近から連続して
  /// `RetryBackoffExhaustionRateAlert.isSystemicFailure`が`true`と判定
  /// された回数）が[recurrenceThreshold]以上であれば、繰り返し発生と
  /// 判定する。
  bool isRecurring(int consecutiveSystemicFailureCount) {
    return consecutiveSystemicFailureCount >= recurrenceThreshold;
  }
}
