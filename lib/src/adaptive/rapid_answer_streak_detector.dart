/// 解答にかかった時間が人間の反応速度として不自然に短い状態が連続して
/// いないかを検知する純関数。`AnswerLatencyOutlierFlag`（個々の解答が
/// 極端に短い/長いかの単発判定）とは異なり、本クラスは「速すぎる」側の
/// 判定が何回連続しているかのみを見る独立した観点で、不正操作（総当たり
/// 等）の可能性に気づく手がかりとする。実際の不正判定・ペナルティ処理は
/// アプリ側の責務とする。
class RapidAnswerStreakDetector {
  const RapidAnswerStreakDetector({
    this.minimumPlausible = const Duration(milliseconds: 300),
    this.streakThreshold = 5,
  });

  /// これより短い解答時間は「速すぎる」とみなす。
  final Duration minimumPlausible;

  /// 「速すぎる」解答が何回連続すれば疑わしい連続とみなすか。
  final int streakThreshold;

  /// [latenciesNewestFirst]（直近の解答から新しい順の解答時間列）の先頭
  /// から数えて、[minimumPlausible]未満の「速すぎる」解答が連続している
  /// 回数が[streakThreshold]以上であれば、疑わしい連続とみなす。
  bool isSuspiciousStreak(List<Duration> latenciesNewestFirst) {
    var consecutiveRapidAnswers = 0;
    for (final latency in latenciesNewestFirst) {
      if (latency >= minimumPlausible) break;
      consecutiveRapidAnswers++;
    }
    return consecutiveRapidAnswers >= streakThreshold;
  }
}
