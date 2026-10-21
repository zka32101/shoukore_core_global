/// `LocaleCurriculumStalenessNotice`によるロケール切替後のカリキュラム
/// 未読み込み通知が連続して無視され続けている状態を検知する純関数。
/// `LocaleCurriculumStalenessNotice`自体は現在のロケールと最後に読み込んだ
/// カリキュラムのロケールが一致するかの単発判定のみを行い、出した後に
/// ユーザーがどう反応したかは見ない。実際のカリキュラム再読み込みの促し
/// 方の見直しはアプリ側の責務とする。
class LocaleCurriculumStalenessNoticeDismissalStreakDetector {
  const LocaleCurriculumStalenessNoticeDismissalStreakDetector({this.dismissalThreshold = 3})
      : assert(dismissalThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int dismissalThreshold;

  /// [consecutiveDismissalCount]（直近から連続して無視された未読み込み
  /// 通知の回数）が[dismissalThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyDismissed(int consecutiveDismissalCount) {
    return consecutiveDismissalCount >= dismissalThreshold;
  }
}
