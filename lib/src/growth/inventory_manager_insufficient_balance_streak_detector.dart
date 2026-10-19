/// `InventoryManager.canPurchase`が残高不足で購入不可と判定され続けている
/// （欲しいアイテムに対して残高が足りない状態が連続している）ことを
/// 検知する純関数。`InventoryManager`自体は1回の購入可否判定のみを行い、
/// 不可判定が連続しているかは見ない。`CoinSpendingLimit`は1日あたりの
/// 消費上限の判定のみを見るため、残高不足そのものの連続は見ない。実際の
/// 「コインを増やす方法」案内の表示はアプリ側の責務とする。
class InventoryManagerInsufficientBalanceStreakDetector {
  const InventoryManagerInsufficientBalanceStreakDetector({this.streakThreshold = 3});

  /// 連続してこの回数以上残高不足で購入を試みたら検知対象とみなす。
  final int streakThreshold;

  /// [consecutiveInsufficientBalanceCount]（直近から連続して残高不足で
  /// 購入できなかった試行の回数）が[streakThreshold]以上であれば、
  /// 検知対象と判定する。
  bool isPersistentlyInsufficient(int consecutiveInsufficientBalanceCount) {
    return consecutiveInsufficientBalanceCount >= streakThreshold;
  }
}
