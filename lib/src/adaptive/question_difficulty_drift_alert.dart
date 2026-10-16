/// `AdaptiveDifficulty`が算出する難易度が、短期間に大きく変動した場合の
/// 異常検知用アラートを判定する純関数。不正操作（チート）や極端な得点
/// パターンの手がかりとして使う想定で、難易度調整ロジック自体
/// （`AdaptiveDifficulty`）は変更しない。実際のアラート対応（通知・
/// 保護者への報告等）はアプリ側の責務とする。
class QuestionDifficultyDriftAlert {
  const QuestionDifficultyDriftAlert({this.driftThreshold = 0.4});

  /// 直近の難易度変化量がこれ以上であれば異常とみなす。
  final double driftThreshold;

  /// [previousDifficulty]から[currentDifficulty]への変化量（絶対値）が
  /// [driftThreshold]以上であれば、異常な難易度変動としてアラート対象と
  /// 判定する。
  bool isDrifting({required double previousDifficulty, required double currentDifficulty}) {
    return (currentDifficulty - previousDifficulty).abs() >= driftThreshold;
  }
}
