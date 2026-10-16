/// 直近の出題履歴（単元ID等のタグ列）が同じものに偏りすぎていないかを
/// 判定する純関数。出題の多様性が失われると学習の網羅性が下がるため、
/// 連続する同一タグの件数が閾値を超えた場合に次回の出題選定で別の単元を
/// 優先すべきと判定するだけで、実際の出題選定ロジック自体はアプリ側の
/// 責務とする。
class QuestionVarietyBiasDetector {
  const QuestionVarietyBiasDetector({this.maxConsecutiveSameTag = 5});

  /// 同一タグの出題がこの件数連続すると偏りとみなす。
  final int maxConsecutiveSameTag;

  /// [recentTagsNewestFirst]（新しい順の出題タグ列）の先頭から見て、
  /// 同一タグが[maxConsecutiveSameTag]件以上連続していれば偏りと判定する。
  bool isBiased(List<String> recentTagsNewestFirst) {
    if (recentTagsNewestFirst.length < maxConsecutiveSameTag) return false;
    final first = recentTagsNewestFirst.first;
    return recentTagsNewestFirst.take(maxConsecutiveSameTag).every((tag) => tag == first);
  }
}
