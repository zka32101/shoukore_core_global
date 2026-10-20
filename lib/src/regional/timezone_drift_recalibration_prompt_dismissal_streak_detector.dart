/// `TimeZoneDriftRecalibrationPrompt`によるタイムゾーン再確認プロンプトが
/// 連続して無視され続けている状態を検知する純関数。
/// `TimeZoneDriftRecalibrationPrompt`自体は連続ドリフト観測回数のみを見る
/// 単発判定であり、出した後にユーザーがどう反応したかは見ない。実際の
/// 表示方法の見直し案内はアプリ側の責務とする。
class TimeZoneDriftRecalibrationPromptDismissalStreakDetector {
  const TimeZoneDriftRecalibrationPromptDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された再確認プロンプト
  /// の回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
