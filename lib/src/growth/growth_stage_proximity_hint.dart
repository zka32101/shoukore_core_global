import 'growth_stage.dart';

/// `GrowthStageCalculator`が判定するキャラ進化段階について、次の段階
/// まで残り何回正答が必要かを算出する純関数。`GrowthStageCalculator`
/// 自体は現在の段階のみを返し、次の段階までの近さは見ないため、本
/// クラスがそれを補う。`AchievementProximityHint`と同様の考え方を
/// `GrowthStage`に適用したもの。実際の「もうすぐ進化！」のような
/// UI表示自体はアプリ側の責務とする。
class GrowthStageProximityHint {
  const GrowthStageProximityHint({
    this.calculator = const GrowthStageCalculator(),
  });

  final GrowthStageCalculator calculator;

  /// [totalCorrectAnswers]（累計正答数）から見て、次の進化段階まで
  /// 残り何回の正答が必要かを返す。すでに最終段階（adult）であれば
  /// `null`を返す。
  int? remainingToNextStage(int totalCorrectAnswers) {
    final stage = calculator.stageFor(totalCorrectAnswers);
    final thresholds = calculator.thresholds;

    final nextThreshold = switch (stage) {
      GrowthStage.egg => thresholds[0],
      GrowthStage.baby => thresholds[1],
      GrowthStage.child => thresholds[2],
      GrowthStage.adult => null,
    };

    if (nextThreshold == null) {
      return null;
    }
    return nextThreshold - totalCorrectAnswers;
  }
}
