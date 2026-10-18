/// `AdaptiveDifficulty`が算出する難易度が一定期間変化していない停滞
/// 状態を検知する純関数。`AdaptiveDifficulty`自体は正誤結果列・最終
/// 練習日から次回の難易度を算出するのみで、算出結果が連続して同じ値の
/// ままかどうかは見ない。実際の単元切り替え提案・休憩提案はアプリ側の
/// 責務とする。
class AdaptiveDifficultyPlateauDetector {
  const AdaptiveDifficultyPlateauDetector({this.plateauThreshold = 5});

  /// 同じ難易度がこの回数以上連続すれば停滞とみなす。
  final int plateauThreshold;

  /// [recentDifficultiesNewestFirst]（直近の算出済み難易度、新しい順）の
  /// 先頭から[plateauThreshold]件が全て同じ値であれば、停滞と判定する。
  /// 件数が[plateauThreshold]未満の場合は`false`を返す。
  bool isPlateaued(List<double> recentDifficultiesNewestFirst) {
    if (recentDifficultiesNewestFirst.length < plateauThreshold) return false;
    final recent = recentDifficultiesNewestFirst.take(plateauThreshold);
    return recent.toSet().length == 1;
  }
}
