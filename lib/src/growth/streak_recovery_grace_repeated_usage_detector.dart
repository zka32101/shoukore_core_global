/// `StreakRecoveryGrace`による学習ストリークの見逃し猶予が、連続して
/// 使われ続けている（毎回ギリギリで猶予に頼っている）状態を検知する
/// 純関数。`StreakRecoveryGrace`自体は1回の見逃しが許容範囲かどうかの
/// 単発判定のみを行い、繰り返し使われているかは見ない。
/// `MissionSkipStreakCap`はミッション見逃しの連続上限のみを見るもので
/// あり、見逃し猶予の利用頻度とは別軸の判定である。実際の学習習慣の
/// 見直し案内はアプリ側の責務とする。
class StreakRecoveryGraceRepeatedUsageDetector {
  const StreakRecoveryGraceRepeatedUsageDetector({this.repeatedUsageThreshold = 3})
      : assert(repeatedUsageThreshold > 0);

  /// 連続してこの回数以上見逃し猶予が使われたら繰り返しパターンとみなす。
  final int repeatedUsageThreshold;

  /// [consecutiveGraceUsageCount]（直近から連続して見逃し猶予が使用された
  /// 回数）が[repeatedUsageThreshold]以上であれば繰り返しパターンと判定
  /// する。
  bool isRepeatedlyUsed(int consecutiveGraceUsageCount) {
    return consecutiveGraceUsageCount >= repeatedUsageThreshold;
  }
}
