enum GrowthStage { egg, baby, child, adult }

/// 累計正答数からキャラ進化段階を計算する純関数。閾値は差し替え可能
/// （RemoteConfig等の外部設定には依存しない。既定値はローカル定数）。
class GrowthStageCalculator {
  const GrowthStageCalculator({this.thresholds = const [10, 50, 150]});

  /// [baby, child, adult] に進化するための累計正答数の閾値。
  final List<int> thresholds;

  GrowthStage stageFor(int totalCorrectAnswers) {
    if (totalCorrectAnswers >= thresholds[2]) return GrowthStage.adult;
    if (totalCorrectAnswers >= thresholds[1]) return GrowthStage.child;
    if (totalCorrectAnswers >= thresholds[0]) return GrowthStage.baby;
    return GrowthStage.egg;
  }
}
