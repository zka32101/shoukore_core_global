/// `AdaptiveDifficulty`が算出する難易度が上下に何度も反転し、安定しない
/// 振動状態を検知する純関数。`AdaptiveDifficultyPlateauDetector`は値が
/// 変化しない停滞のみを見るため逆方向の軸であり、`QuestionDifficultyDriftAlert`
/// は一方向への緩やかな偏りのみを見るため、反転の繰り返しは見ない。
/// 実際の難易度調整ロジックの見直し・単元切り替え提案はアプリ側の責務
/// とする。
class AdaptiveDifficultyOscillationDetector {
  const AdaptiveDifficultyOscillationDetector({this.reversalThreshold = 4});

  /// 直近の反転（上昇→下降、または下降→上昇への切り替わり）がこの回数
  /// 以上であれば振動とみなす。
  final int reversalThreshold;

  /// [recentDifficultiesOldestFirst]（直近の算出済み難易度、古い順）の
  /// 連続する差分の符号が反転した回数が[reversalThreshold]以上であれば、
  /// 振動状態と判定する。
  bool isOscillating(List<double> recentDifficultiesOldestFirst) {
    if (recentDifficultiesOldestFirst.length < 3) return false;

    var reversalCount = 0;
    int? previousSign;
    for (var i = 1; i < recentDifficultiesOldestFirst.length; i++) {
      final diff =
          recentDifficultiesOldestFirst[i] - recentDifficultiesOldestFirst[i - 1];
      if (diff == 0) continue;
      final sign = diff > 0 ? 1 : -1;
      if (previousSign != null && sign != previousSign) {
        reversalCount++;
      }
      previousSign = sign;
    }
    return reversalCount >= reversalThreshold;
  }
}
