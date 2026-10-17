import '../models/models.dart';
import 'mastery_decay.dart';

/// `MasteryDecay`による減衰量が大きい単元を優先的に知らせるべきかを
/// 判定する純関数。`MasteryDecay`自体は減衰後のスコアを計算するのみで
/// 単元間の比較は行わないため、本クラスが元のスコアとの差分を見る。
/// 実際の優先表示・通知はアプリ側の責務とする。
class MasteryRapidDecayDetector {
  const MasteryRapidDecayDetector({
    this.decayAmountThreshold = 0.3,
    MasteryDecay? masteryDecay,
  }) : masteryDecay = masteryDecay ?? const MasteryDecay();

  /// 減衰量（元のスコア-減衰後スコア）がこれ以上であれば急激とみなす。
  final double decayAmountThreshold;

  final MasteryDecay masteryDecay;

  /// [mastery]の[now]時点での減衰量が[decayAmountThreshold]以上であれば
  /// 急激な減衰と判定する。
  bool isDecayingRapidly(Mastery mastery, DateTime now) {
    final decayed = masteryDecay.decayedScore(mastery, now);
    return (mastery.score - decayed) >= decayAmountThreshold;
  }
}
