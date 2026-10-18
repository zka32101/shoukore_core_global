/// 直近の出題に同じ問題（問題ID単位）が繰り返し出されすぎている疲労状態を
/// 検知する純関数。`QuestionVarietyBiasDetector`は単元タグ単位の偏りのみ
/// を見るため、問題インスタンス自体が繰り返されているかどうかは見ない。
/// 実際の出題プールからの除外・差し替えはアプリ側の責務とする。
class QuestionRepetitionFatigueDetector {
  const QuestionRepetitionFatigueDetector({this.repetitionThreshold = 2});

  /// 直近の出題件数のうち、同一問題IDがこの件数以上含まれていれば疲労
  /// とみなす。
  final int repetitionThreshold;

  /// [recentQuestionIds]（直近の出題問題ID列）のうち、最も頻出する問題IDの
  /// 出現回数が[repetitionThreshold]以上であれば、疲労状態と判定する。
  bool isFatigued(List<String> recentQuestionIds) {
    if (recentQuestionIds.isEmpty) return false;
    final counts = <String, int>{};
    for (final id in recentQuestionIds) {
      counts[id] = (counts[id] ?? 0) + 1;
    }
    final maxCount = counts.values.reduce((a, b) => a > b ? a : b);
    return maxCount >= repetitionThreshold;
  }
}
