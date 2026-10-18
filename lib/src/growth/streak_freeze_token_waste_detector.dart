/// `MissionStreakFreezeToken`によるストリークフリーズトークンが使われず
/// 失効し続けている無駄遣い状態を検知する純関数。`MissionStreakFreezeToken`
/// 自体はトークンを消費すべきかどうかの適用ロジックのみを行い、未使用の
/// まま失効した回数は見ないため、本クラスが独立してその判定を行う。
/// 実際の「トークンを早めに使おう」案内の表示はアプリ側の責務とする。
class StreakFreezeTokenWasteDetector {
  const StreakFreezeTokenWasteDetector({this.wasteThreshold = 3});

  /// 未使用のまま失効した回数がこの回数以上になったら無駄遣いとみなす。
  final int wasteThreshold;

  /// [consecutiveExpiredUnusedCount]（直近から連続して未使用のまま
  /// 失効したトークンの回数）が[wasteThreshold]以上であれば、無駄遣い
  /// 状態と判定する。
  bool isWastingTokens(int consecutiveExpiredUnusedCount) {
    return consecutiveExpiredUnusedCount >= wasteThreshold;
  }
}
