import 'growth_stage.dart';

/// 成長段階（[GrowthStage]）が最後に進化してから長期間変化していない
/// 停滞状態を検知する純関数。`GrowthStageRegressionGuard`は段階が後退
/// していないかのみを見るため、変化がないまま停滞している状態は見ない。
/// 実際の「学習を続けよう」案内の表示はアプリ側の責務とする。
class GrowthStageStallDetector {
  const GrowthStageStallDetector({this.stallPeriod = const Duration(days: 14)});

  /// 最後に進化してからこの期間を超えて変化がなければ停滞とみなす。
  final Duration stallPeriod;

  /// [currentStage]がまだ最終段階（[GrowthStage.adult]）に達していない
  /// 状態で、[lastEvolvedAt]（最後に進化した時刻）から[now]までの経過が
  /// [stallPeriod]を超えていれば停滞と判定する。既に最終段階の場合は
  /// 停滞と判定しない（それ以上の進化を期待しないため）。
  bool isStalled({
    required GrowthStage currentStage,
    required DateTime lastEvolvedAt,
    required DateTime now,
  }) {
    if (currentStage == GrowthStage.adult) return false;
    return now.difference(lastEvolvedAt) > stallPeriod;
  }
}
