/// クロスプロモーション案内を無視した後、再表示までのクールダウン
/// 期間が過ぎたかを判定する純関数。`CrossPromoEligibilityDetector`
/// は無視した累計回数のみを見るため、直近いつ無視されたかは見ない。
/// 本クラスがそれを補い、無視された直後に再表示してしまうことを
/// 防ぐ。実際の案内表示自体はアプリ側の責務とする。
class CrossPromoDismissalCooldown {
  const CrossPromoDismissalCooldown({
    this.cooldownDuration = const Duration(days: 7),
  });

  /// 無視されてから再表示までのクールダウン期間。
  final Duration cooldownDuration;

  /// [lastDismissedAt]（直前に無視された時刻）が`null`であれば常に
  /// 表示可能と判定する。それ以外は、[now]との差が
  /// [cooldownDuration]以上であれば表示可能と判定する。
  bool isCooldownOver(DateTime? lastDismissedAt, DateTime now) {
    if (lastDismissedAt == null) {
      return true;
    }
    return now.difference(lastDismissedAt) >= cooldownDuration;
  }
}
