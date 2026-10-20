/// `StreakRiskAlert`によるストリーク途切れ警告が連続して無視され続けて
/// いる状態を検知する純関数。`StreakRiskAlert`自体は当日未学習かつ
/// 残り時間が少ないかどうかの単発判定のみを行い、出した後にユーザーが
/// どう反応したかは見ない。実際の表示方法の見直し案内はアプリ側の責務
/// とする。
class StreakRiskAlertDismissalStreakDetector {
  const StreakRiskAlertDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視されたストリーク
  /// 途切れ警告の回数）が[dismissalThreshold]以上であれば、連続無視状態
  /// と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
