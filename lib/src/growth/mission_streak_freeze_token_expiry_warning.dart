/// 保有しているストリークフリーズトークンが期限切れになる前に、使い道を
/// 案内すべきかを判定する純関数。`StreakFreezeTokenWasteDetector`は期限
/// 切れ後（未使用のまま失効した回数）のみを見るため、期限切れ前の事前
/// 警告は見ない。`MissionStreakFreezeToken`自体はストリーク途切れ時に
/// トークンを消費すべきかの判定のみを行い、期限管理は見ない。実際の
/// 「もうすぐ失効します」表示はアプリ側の責務とする。
class MissionStreakFreezeTokenExpiryWarning {
  const MissionStreakFreezeTokenExpiryWarning({
    this.remainingTimeThreshold = const Duration(days: 3),
  });

  /// トークンの失効までこの時間を切ったら「もうすぐ失効」とみなす。
  final Duration remainingTimeThreshold;

  /// [expiresAt]（トークンの失効予定時刻）までの、[now]からの残り時間が
  /// [remainingTimeThreshold]以下であれば失効間近と判定する。既に失効
  /// している場合は`false`を返す。
  bool isExpiringSoon({required DateTime expiresAt, required DateTime now}) {
    if (now.isAfter(expiresAt)) return false;
    return expiresAt.difference(now) <= remainingTimeThreshold;
  }
}
