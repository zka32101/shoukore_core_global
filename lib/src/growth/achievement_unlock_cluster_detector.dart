import 'achievement.dart';

/// `AchievementEvaluator.newlyUnlocked`が一度に複数のバッジ解除を返した
/// 場合、それらの祝賀表示を同時に出さず分散させるべきかを判定する純関数。
/// `AchievementEvaluator`自体は解除済みバッジの集合計算のみを行い、
/// 同時に複数解除された際の表示順序・分散は見ない。`AchievementProximityHint`
/// は未解除バッジの残り進捗のみを見る。実際の祝賀表示の分散・順序付けは
/// アプリ側の責務とする。
class AchievementUnlockClusterDetector {
  const AchievementUnlockClusterDetector({this.clusterThreshold = 2});

  /// 同時解除数がこの件数以上であれば密集（クラスター）とみなす。
  final int clusterThreshold;

  /// [newlyUnlocked]（同一の評価で新たに解除されたバッジ集合）の件数が
  /// [clusterThreshold]以上であれば、分散表示が必要と判定する。
  bool isClustered(Set<AchievementId> newlyUnlocked) {
    return newlyUnlocked.length >= clusterThreshold;
  }
}
