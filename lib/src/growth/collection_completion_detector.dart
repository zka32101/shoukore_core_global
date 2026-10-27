/// キャラクター・アイテムなどの収集コレクションが、達成通知を
/// 出すべき節目（コンプリート、または一定割合の到達）に達した
/// かどうかを判定する純関数。「集める楽しみ」を達成実感に繋げる
/// 場面向け。実際の達成演出・通知表示自体はアプリ側の責務とする。
class CollectionCompletionDetector {
  const CollectionCompletionDetector({
    this.milestoneRatios = const [0.5, 0.8, 1.0],
  });

  /// 達成通知を出す節目となる、収集進捗の比率（0.0〜1.0）。
  final List<double> milestoneRatios;

  /// [ownedCount]（所持済み数）/[totalCount]（収集対象の総数）の
  /// 比率が[milestoneRatios]のいずれかにちょうど到達していれば、
  /// 達成通知の対象と判定する。[totalCount]が0の場合は対象外。
  bool isMilestoneReached(int ownedCount, int totalCount) {
    if (totalCount <= 0) {
      return false;
    }
    final ratio = ownedCount / totalCount;
    return milestoneRatios.any((milestone) => ratio >= milestone);
  }
}
