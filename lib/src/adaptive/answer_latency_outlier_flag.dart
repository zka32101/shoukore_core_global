/// 解答にかかった時間が極端に短い、または極端に長い場合に異常値として
/// フラグを立てるべきかを判定する純関数。`QuestionDifficultyDriftAlert`
/// （難易度の変動検知）とは異なり、個々の解答の所要時間のみを見る。
/// 実際の異常値への対応（アラート・保護者への報告等）はアプリ側の
/// 責務とする。
class AnswerLatencyOutlierFlag {
  const AnswerLatencyOutlierFlag({
    this.minimumPlausible = const Duration(milliseconds: 300),
    this.maximumPlausible = const Duration(minutes: 5),
  });

  /// これより短い解答時間は異常（短すぎ）とみなす。
  final Duration minimumPlausible;

  /// これより長い解答時間は異常（長すぎ）とみなす。
  final Duration maximumPlausible;

  /// [latency]が[minimumPlausible]未満、または[maximumPlausible]を超える
  /// 場合に異常値と判定する。
  bool isOutlier(Duration latency) {
    return latency < minimumPlausible || latency > maximumPlausible;
  }
}
