import '../models/models.dart';

/// 一度学習を始めた単元（`Mastery.score`>0）が、長期間再学習されずに
/// 未習熟のまま放置されている状態を検知する純関数。
/// `MasteryAcrossUnitsStagnationDetector`は複数単元の習熟度スナップ
/// ショットを一定期間おきに比較する仕組みであり、単一単元が開始後に
/// 放置されているかは見ない。`MasteryDecay`はスコアの時間減衰値を計算
/// するのみで、放置状態自体の判定は行わない。実際の「もう一度やって
/// みよう」案内の表示はアプリ側の責務とする。
class UnitAbandonmentDetector {
  const UnitAbandonmentDetector({
    this.masteredScoreThreshold = 0.8,
    this.abandonedAfter = const Duration(days: 30),
  }) : assert(masteredScoreThreshold > 0),
       assert(masteredScoreThreshold <= 1);

  /// このスコア以上であれば習熟済みとみなし、放置判定の対象外とする。
  final double masteredScoreThreshold;

  /// 最後の学習からこの期間を超えて放置されていれば放置とみなす。
  final Duration abandonedAfter;

  /// [mastery]が学習済み（`score`>0）かつ未習熟（[masteredScoreThreshold]
  /// 未満）であり、[Mastery.lastPracticedAt]から[now]までの経過が
  /// [abandonedAfter]を超えていれば放置状態と判定する。一度も学習して
  /// いない単元（`score`が0）は対象外とする。
  bool isAbandoned({required Mastery mastery, required DateTime now}) {
    if (mastery.score <= 0) return false;
    if (mastery.score >= masteredScoreThreshold) return false;
    final lastPracticedAt = mastery.lastPracticedAt;
    if (lastPracticedAt == null) return false;
    return now.difference(lastPracticedAt) > abandonedAfter;
  }
}
