import '../models/models.dart';

/// 単元内の誤解傾向（誤解タイプ→回数）。
class WeakNote {
  const WeakNote({required this.unitId, required this.misconceptionCounts});

  final String unitId;
  final Map<String, int> misconceptionCounts;

  bool get hasWeakness => misconceptionCounts.isNotEmpty;
}

/// `Attempt.chosenId` と `Question.misconceptionTags` から、単元ごとの
/// 誤解傾向を集計する純関数。誤答選択肢に誤解タグが付いていない問題は無視する。
class WeakNotesAnalyzer {
  const WeakNotesAnalyzer();

  WeakNote analyze({
    required String unitId,
    required List<Attempt> attempts,
    required Question Function(String questionId) questionLookup,
  }) {
    final counts = <String, int>{};
    for (final attempt in attempts) {
      if (attempt.correct || attempt.chosenId == null) continue;
      final question = questionLookup(attempt.questionId);
      final tag = question.misconceptionTags[attempt.chosenId];
      if (tag == null) continue;
      counts[tag] = (counts[tag] ?? 0) + 1;
    }
    return WeakNote(unitId: unitId, misconceptionCounts: counts);
  }

  /// 最も頻出する誤解タイプ。同数の場合は先に数えられた方を返す。
  String? topMisconception(WeakNote note) {
    if (note.misconceptionCounts.isEmpty) return null;
    final sorted = note.misconceptionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  /// 指定した誤解タイプについて、直近[consecutiveCorrectRequired]件が連続正解であり、
  /// それより前に同じ誤解タイプの誤答があった場合に「克服した」と判定する。
  /// [attemptsNewestFirst] は新しい順（先頭が最新）であること。
  bool isOvercome({
    required List<Attempt> attemptsNewestFirst,
    required Question Function(String questionId) questionLookup,
    required String misconceptionTag,
    int consecutiveCorrectRequired = 3,
  }) {
    if (attemptsNewestFirst.length < consecutiveCorrectRequired) return false;

    final recent = attemptsNewestFirst.take(consecutiveCorrectRequired);
    if (recent.any((a) => !a.correct)) return false;

    final older = attemptsNewestFirst.skip(consecutiveCorrectRequired);
    for (final attempt in older) {
      if (attempt.correct || attempt.chosenId == null) continue;
      final question = questionLookup(attempt.questionId);
      if (question.misconceptionTags[attempt.chosenId] == misconceptionTag) {
        return true;
      }
    }
    return false;
  }
}
