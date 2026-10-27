/// 直近の正答率の履歴から、学習の調子が上向きか下向きかを判定する
/// 純関数。既存の検出器群は単発の閾値判定が中心だが、本クラスは
/// 履歴を前半・後半に分けて平均正答率を比較し、傾向（improving /
/// steady / declining）を返す。実際の傾向表示・励ましメッセージ
/// 自体はアプリ側の責務とする。
enum AccuracyTrend { improving, steady, declining }

class AccuracyTrendDetector {
  const AccuracyTrendDetector({this.flatThreshold = 0.05})
      : assert(flatThreshold >= 0);

  /// 前半・後半の平均正答率の差がこの値未満であれば「steady」とみなす。
  final double flatThreshold;

  /// [recentAccuracyRatios]（古い順の直近の正答率、各0.0〜1.0）を
  /// 前半・後半に分けて平均を比較する。要素数が2未満の場合は判定材料
  /// が不足しているため`steady`を返す。
  AccuracyTrend evaluateTrend(List<double> recentAccuracyRatios) {
    if (recentAccuracyRatios.length < 2) {
      return AccuracyTrend.steady;
    }

    final mid = recentAccuracyRatios.length ~/ 2;
    final firstHalf = recentAccuracyRatios.sublist(0, mid);
    final secondHalf = recentAccuracyRatios.sublist(mid);

    final firstAverage = _average(firstHalf);
    final secondAverage = _average(secondHalf);
    final difference = secondAverage - firstAverage;

    if (difference > flatThreshold) {
      return AccuracyTrend.improving;
    }
    if (difference < -flatThreshold) {
      return AccuracyTrend.declining;
    }
    return AccuracyTrend.steady;
  }

  double _average(List<double> values) {
    return values.reduce((a, b) => a + b) / values.length;
  }
}
