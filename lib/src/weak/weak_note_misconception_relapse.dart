import '../models/models.dart';

/// `WeakNotesAnalyzer.isOvercome()`で一度「克服した」と判定された誤解が、
/// その後再び同じ誤解タイプで誤答された（再発した）かを判定する純関数。
/// `WeakNotesAnalyzer`自体は克服判定のみを行い、克服後の再発は見ないため、
/// 本クラスが克服と判定された時刻以降の誤答のみを見る。実際の再学習の
/// 案に表示・保護者への報告はアプリ側の責務とする。
class WeakNoteMisconceptionRelapse {
  const WeakNoteMisconceptionRelapse();

  /// [attemptsOldestFirst]（古い順の解答履歴）のうち、[overcomeAt]より後に
  /// [misconceptionTag]と同じ誤解タイプで誤答したものがあれば再発と判定する。
  bool hasRelapsed({
    required List<Attempt> attemptsOldestFirst,
    required Question Function(String questionId) questionLookup,
    required String misconceptionTag,
    required DateTime overcomeAt,
  }) {
    for (final attempt in attemptsOldestFirst) {
      if (!attempt.answeredAt.isAfter(overcomeAt)) continue;
      if (attempt.correct || attempt.chosenId == null) continue;
      final question = questionLookup(attempt.questionId);
      if (question.misconceptionTags[attempt.chosenId] == misconceptionTag) {
        return true;
      }
    }
    return false;
  }
}
