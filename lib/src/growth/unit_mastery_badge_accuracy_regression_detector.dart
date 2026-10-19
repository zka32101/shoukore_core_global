import '../models/models.dart';

/// 単元マスターバッジを獲得した後、その単元の正答率が再び悪化していない
/// かを判定する純関数。`UnitMasteryBadgeEligibility`自体はマスター済み
/// かどうかの二値判定のみを行い、マスター後のスコアの変化は見ない。
/// `UnitMasteryBadgeMotivationDropNotice`はマスター後の無活動期間のみを
/// 見るため、解答自体は続けているが正答率が落ちている状態は見ない。
/// 実際の再学習案の表示はアプリ側の責務とする。
class UnitMasteryBadgeAccuracyRegressionDetector {
  const UnitMasteryBadgeAccuracyRegressionDetector({
    this.recentAttemptCount = 5,
    this.accuracyDropThreshold = 0.3,
  })  : assert(recentAttemptCount > 0),
        assert(accuracyDropThreshold > 0);

  /// マスター後の正答率を見る直近の解答件数。
  final int recentAttemptCount;

  /// マスター判定時の正答率との差がこれ以上であれば悪化とみなす。
  final double accuracyDropThreshold;

  /// [masteredAccuracy]（マスター判定時点の正答率）に対して、
  /// [attemptsAfterMasteryNewestFirst]（マスター後の解答履歴、新しい順）
  /// の直近[recentAttemptCount]件の正答率が[accuracyDropThreshold]以上
  /// 下がっていれば悪化と判定する。マスター後の解答件数が
  /// [recentAttemptCount]未満の場合は判定しない。
  bool hasRegressed({
    required double masteredAccuracy,
    required List<Attempt> attemptsAfterMasteryNewestFirst,
  }) {
    if (attemptsAfterMasteryNewestFirst.length < recentAttemptCount) return false;
    final recent = attemptsAfterMasteryNewestFirst.take(recentAttemptCount);
    final correctCount = recent.where((a) => a.correct).length;
    final recentAccuracy = correctCount / recentAttemptCount;
    return (masteredAccuracy - recentAccuracy) >= accuracyDropThreshold;
  }
}
