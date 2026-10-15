import '../models/models.dart';

/// 単元ごとに「マスター」バッジを付与すべきかを判定する純関数。
/// `Achievement`（ストリーク・累計正答数という教科非依存の全体指標）とは
/// 異なり、単元単位の直近の正答率を見るだけで、バッジの永続化・通知表示は
/// アプリ側の責務とする。
class UnitMasteryBadgeEligibility {
  const UnitMasteryBadgeEligibility({
    this.requiredAttempts = 10,
    this.requiredAccuracy = 0.9,
  })  : assert(requiredAttempts > 0),
        assert(requiredAccuracy > 0 && requiredAccuracy <= 1);

  /// マスター判定に必要な直近の解答件数。
  final int requiredAttempts;

  /// マスター判定に必要な正答率（直近[requiredAttempts]件中）。
  final double requiredAccuracy;

  /// [attemptsNewestFirst]（単一unitId・新しい順）が[requiredAttempts]件以上
  /// あり、直近[requiredAttempts]件の正答率が[requiredAccuracy]以上なら
  /// マスター済みと判定する。
  bool isMastered(List<Attempt> attemptsNewestFirst) {
    if (attemptsNewestFirst.length < requiredAttempts) return false;
    final recent = attemptsNewestFirst.take(requiredAttempts);
    final correctCount = recent.where((a) => a.correct).length;
    return correctCount / requiredAttempts >= requiredAccuracy;
  }
}
