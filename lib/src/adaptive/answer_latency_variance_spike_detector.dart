import 'dart:math' as math;

/// 直近の解答時間が、全体として遅くなっているわけではなく速い解答と
/// 遅い解答が交互に続くような不安定さ（バラつき）を見せているかを判定
/// する純関数。`AnswerLatencyOutlierFlag`は個々の解答1件の異常値のみを
/// 見るため、複数件にわたる不安定さは見ない。`AnswerLatencyFatigueTrend`
/// は前半・後半の平均を比較した一方向の低下傾向のみを見るため、方向性の
/// ないバラつき自体は見ない。実際の集中力低下への対応・通知はアプリ側
/// の責務とする。
class AnswerLatencyVarianceSpikeDetector {
  const AnswerLatencyVarianceSpikeDetector({
    this.minimumSampleSize = 6,
    this.varianceRatioThreshold = 0.6,
  }) : assert(minimumSampleSize >= 2);

  /// 判定に必要な最小解答件数。これ未満なら判定しない。
  final int minimumSampleSize;

  /// 標準偏差を平均で割った値（変動係数）がこの値以上であれば不安定と
  /// みなす。
  final double varianceRatioThreshold;

  /// [latenciesOldestFirst]（古い順の解答時間列）の変動係数が
  /// [varianceRatioThreshold]以上であれば、不安定さが急増していると
  /// 判定する。
  bool isSpiking(List<Duration> latenciesOldestFirst) {
    if (latenciesOldestFirst.length < minimumSampleSize) return false;

    final microseconds = latenciesOldestFirst.map((d) => d.inMicroseconds).toList();
    final average = microseconds.reduce((a, b) => a + b) / microseconds.length;
    if (average == 0) return false;

    final variance = microseconds
            .map((v) => (v - average) * (v - average))
            .reduce((a, b) => a + b) /
        microseconds.length;
    final coefficientOfVariation = math.sqrt(variance) / average;

    return coefficientOfVariation >= varianceRatioThreshold;
  }
}
