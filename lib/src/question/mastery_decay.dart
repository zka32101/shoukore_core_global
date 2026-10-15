import 'dart:math' as math;

import '../models/models.dart';

/// 一定期間学習していない単元の`Mastery.score`を、時間経過に応じて緩やかに
/// 減衰させる純関数。「しばらくやらないと忘れる」を反映し、`UnitRecommendation`
/// 等の入力として使う。`ProgressStore`への保存は行わず、表示・判定用の値を
/// 計算するだけで、永続化された`Mastery`自体を書き換えるものではない。
class MasteryDecay {
  const MasteryDecay({
    this.gracePeriod = const Duration(days: 7),
    this.halfLife = const Duration(days: 14),
  });

  /// 最後の学習からこの期間は減衰させない。
  final Duration gracePeriod;

  /// 減衰の半減期（この期間ごとにscoreが半分になる）。
  final Duration halfLife;

  /// [mastery]の[now]時点での減衰後スコアを計算する。[Mastery.lastPracticedAt]
  /// が未設定（未学習）の場合は減衰させず元のスコアを返す。
  double decayedScore(Mastery mastery, DateTime now) {
    final lastPracticedAt = mastery.lastPracticedAt;
    if (lastPracticedAt == null) return mastery.score;

    final elapsed = now.difference(lastPracticedAt);
    final decayDuration = elapsed - gracePeriod;
    if (decayDuration <= Duration.zero) return mastery.score;

    final halfLives = decayDuration.inMicroseconds / halfLife.inMicroseconds;
    final factor = math.pow(0.5, halfLives) as double;
    return mastery.score * factor;
  }
}
