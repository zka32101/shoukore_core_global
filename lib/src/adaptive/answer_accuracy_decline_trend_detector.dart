/// 直近の解答の正答率が前半と比べて後半に悪化している傾向を判定する
/// 純関数。`UnitMasteryBadgeAccuracyRegressionDetector`はマスターバッジ
/// 獲得後限定で悪化を判定するため、マスター前も含む一般的な正答率悪化
/// 傾向は見ない。`AdaptiveDifficultyPlateauDetector`は難易度算出値自体の
/// 停滞のみを見るため、正答率の変化は見ない。実際の難易度調整・復習
/// 案の表示はアプリ側の責務とする。
class AnswerAccuracyDeclineTrendDetector {
  const AnswerAccuracyDeclineTrendDetector({
    this.minimumSampleSize = 6,
    this.accuracyDropThreshold = 0.3,
  }) : assert(minimumSampleSize >= 2),
       assert(accuracyDropThreshold >= 0);

  /// 判定に必要な最小解答件数。これ未満なら判定しない。
  final int minimumSampleSize;

  /// 前半の正答率から後半の正答率への低下がこの値以上であれば悪化傾向
  /// とみなす。
  final double accuracyDropThreshold;

  /// [correctnessOldestFirst]（古い順の正誤列）を前半・後半に分け、
  /// 前半の正答率から後半の正答率への低下が[accuracyDropThreshold]以上
  /// であれば悪化傾向と判定する。
  bool isDeclining(List<bool> correctnessOldestFirst) {
    if (correctnessOldestFirst.length < minimumSampleSize) return false;

    final half = correctnessOldestFirst.length ~/ 2;
    final firstHalf = correctnessOldestFirst.sublist(0, half);
    final secondHalf = correctnessOldestFirst.sublist(correctnessOldestFirst.length - half);

    final firstAccuracy = _accuracyOf(firstHalf);
    final secondAccuracy = _accuracyOf(secondHalf);

    return firstAccuracy - secondAccuracy >= accuracyDropThreshold;
  }

  double _accuracyOf(List<bool> correctness) {
    final correctCount = correctness.where((c) => c).length;
    return correctCount / correctness.length;
  }
}
