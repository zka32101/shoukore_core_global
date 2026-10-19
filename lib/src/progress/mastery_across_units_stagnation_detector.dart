import '../models/models.dart';

/// 複数単元の習熟度スナップショットを一定期間おきに比較し、どの単元も
/// スコアが向上していない全体的な停滞状態を検知する純関数。
/// `AdaptiveDifficultyPlateauDetector`は単一の難易度算出値列の停滞のみを
/// 見るため、単元をまたいだ習熟度の変化は見ない。`MasteryRapidDecayDetector`
/// は単一単元の減衰量のみを見るため、複数単元が揃って停滞しているかは
/// 見ない。実際の学習内容の見直し提案・通知はアプリ側の責務とする。
class MasteryAcrossUnitsStagnationDetector {
  const MasteryAcrossUnitsStagnationDetector({this.scoreImprovementThreshold = 0.05})
      : assert(scoreImprovementThreshold >= 0);

  /// スコアの向上がこの値未満であれば停滞とみなす。
  final double scoreImprovementThreshold;

  /// [previousMastery]（前回スナップショット時点の単元ごとの習熟度）と
  /// [currentMastery]（現在の単元ごとの習熟度）を比較し、両方に存在する
  /// 単元のうち1件以上でもスコアが[scoreImprovementThreshold]以上向上して
  /// いれば`false`（停滞ではない）を返す。両方に存在する単元が1件もない
  /// 場合も`false`を返す。
  bool isStagnant({
    required List<Mastery> previousMastery,
    required List<Mastery> currentMastery,
  }) {
    final previousByUnit = {for (final m in previousMastery) m.unitId: m.score};
    var comparedAny = false;

    for (final current in currentMastery) {
      final previousScore = previousByUnit[current.unitId];
      if (previousScore == null) continue;
      comparedAny = true;
      if (current.score - previousScore >= scoreImprovementThreshold) {
        return false;
      }
    }

    return comparedAny;
  }
}
