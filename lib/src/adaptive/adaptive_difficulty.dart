import '../clock/clock.dart';

/// 適応難易度の計算。純関数＋[Clock]のみに依存し、RemoteConfig等の外部設定は持たない。
/// 閾値はローカル既定値を持ちつつ、コンストラクタ引数で差し替え可能にする（shared_core失敗#9対策）。
class AdaptiveDifficulty {
  const AdaptiveDifficulty({
    this.step = 0.1,
    this.min = 0.1,
    this.max = 0.95,
    this.upRate = 0.8,
    this.downRate = 0.4,
    this.forgettingThresholdDays = 7,
  })  : assert(min < max),
        assert(downRate < upRate);

  /// 1回の難易度変化量。
  final double step;
  final double min;
  final double max;

  /// 直近正答率がこれ以上なら難易度を上げる。
  final double upRate;

  /// 直近正答率がこれ以下なら難易度を下げる。
  final double downRate;

  /// この日数以上練習が空いたら忘却分として難易度を下げる。
  final int forgettingThresholdDays;

  /// 直近の正誤結果列と最終練習日から、次回の目標難易度を計算する。
  /// [recentResults] は古い順でも新しい順でもよい（正答率のみ使う）。
  double nextDifficulty({
    required double currentDifficulty,
    required List<bool> recentResults,
    DateTime? lastPracticedAt,
    required Clock clock,
  }) {
    var next = currentDifficulty;

    if (recentResults.isNotEmpty) {
      final correctRate = recentResults.where((r) => r).length / recentResults.length;
      if (correctRate >= upRate) {
        next += step;
      } else if (correctRate <= downRate) {
        next -= step;
      }
    }

    if (lastPracticedAt != null) {
      final daysSince = clock.now().difference(lastPracticedAt).inDays;
      if (daysSince >= forgettingThresholdDays) {
        next -= step;
      }
    }

    return next.clamp(min, max);
  }
}
