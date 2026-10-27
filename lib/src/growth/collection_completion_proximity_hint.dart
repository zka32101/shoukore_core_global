import 'collection_completion_detector.dart';

/// `CollectionCompletionDetector`が判定する収集マイルストーンについて、
/// 次の節目まで残り何個の収集が必要かを算出する純関数。
/// `CollectionCompletionDetector`自体は「ちょうど節目に到達したか」
/// の二値判定のみを行い、未到達の節目までの近さは見ないため、本
/// クラスがそれを補う。`AchievementProximityHint`と同様の考え方を
/// `CollectionCompletionDetector`に適用したもの。実際の「もうすぐ
/// コンプリート！」のようなUI表示自体はアプリ側の責務とする。
class CollectionCompletionProximityHint {
  const CollectionCompletionProximityHint({
    this.detector = const CollectionCompletionDetector(),
  });

  final CollectionCompletionDetector detector;

  /// [ownedCount]（所持済み数）/[totalCount]（収集対象の総数）の比率
  /// から見て、次の節目まで残り何個の収集が必要かを返す。[totalCount]
  /// が0、またはすでに全ての節目に到達している場合は`null`を返す。
  int? remainingToNextMilestone(int ownedCount, int totalCount) {
    if (totalCount <= 0) {
      return null;
    }

    final ratio = ownedCount / totalCount;
    final sortedMilestones = [...detector.milestoneRatios]..sort();

    for (final milestone in sortedMilestones) {
      if (ratio < milestone) {
        final requiredCount = (milestone * totalCount).ceil();
        return requiredCount - ownedCount;
      }
    }

    return null;
  }
}
