/// コインが貯まり続けているにもかかわらず長期間使われていない（残高が
/// 滞留している）ことに気づけるようにすべきかを判定する純関数。
/// `CoinWallet`自体は残高の増減のみを行い、使われていない期間は見ない
/// ため、本クラスがアプリ側が別途記録する最終使用時刻と現在の残高を
/// 見て判定する。実際のストア案内・通知表示はアプリ側の責務とする。
class CoinWalletStagnationNotice {
  const CoinWalletStagnationNotice({
    this.stagnationPeriod = const Duration(days: 14),
    this.minimumBalance = 1,
  });

  /// 最後に使ってからこの期間が過ぎたら滞留とみなす。
  final Duration stagnationPeriod;

  /// 残高がこれ未満であれば、使う意味が薄いため滞留とはみなさない。
  final int minimumBalance;

  /// [balance]が[minimumBalance]以上であり、かつ[lastSpentAt]（最後に
  /// 使った時刻、一度も使っていない場合は`null`）から[now]までの経過が
  /// [stagnationPeriod]を超えていれば滞留と判定する。[lastSpentAt]が
  /// `null`の場合は[sinceEarnedAt]（最初に獲得した時刻）を基準にする。
  bool isStagnant({
    required int balance,
    required DateTime? lastSpentAt,
    required DateTime sinceEarnedAt,
    required DateTime now,
  }) {
    if (balance < minimumBalance) return false;
    final baseline = lastSpentAt ?? sinceEarnedAt;
    return now.difference(baseline) > stagnationPeriod;
  }
}
