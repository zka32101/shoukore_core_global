/// 単元内で、カリキュラムが定義する小項目（トピック）のうち、
/// 一度も出題されていないものがないかを検証する純関数。「クイズは
/// すべての範囲をカバーする」という共通要件の検証に使う。実際の
/// カリキュラムJSON読み込み・出題履歴の集計自体はアプリ/ツール側の
/// 責務とする。
class CurriculumCoverageValidator {
  const CurriculumCoverageValidator();

  /// [definedTopicIds]（カリキュラムが定義する小項目ID一覧）のうち、
  /// [coveredTopicIds]（一度でも出題された小項目ID一覧）に含まれない
  /// ものを「未カバー」として返す（空なら全範囲カバー済み）。
  List<String> findUncoveredTopics(
    List<String> definedTopicIds,
    Set<String> coveredTopicIds,
  ) {
    return definedTopicIds
        .where((topicId) => !coveredTopicIds.contains(topicId))
        .toList();
  }
}
