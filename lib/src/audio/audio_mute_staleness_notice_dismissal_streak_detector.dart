/// `AudioMuteStalenessNotice`によるミュート解除確認提案が連続して無視
/// され続けている状態を検知する純関数。`AudioMuteStalenessNotice`自体は
/// ミュートの継続期間のみを見る単発判定であり、出した後にユーザーがどう
/// 反応したかは見ない。実際の表示方法の見直し案内はアプリ側の責務と
/// する。
class AudioMuteStalenessNoticeDismissalStreakDetector {
  const AudioMuteStalenessNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された解除確認提案
  /// の回数）が[dismissalThreshold]以上であれば、連続無視状態と判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
