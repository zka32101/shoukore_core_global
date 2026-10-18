/// コイン消費1回分の記録。
class CoinSpendingEvent {
  const CoinSpendingEvent({required this.amount, required this.spentAt});

  final int amount;
  final DateTime spentAt;
}

/// 短時間に複数回の大きなコイン消費が連続していないか（想定外の連続購入）
/// を検知する純関数。`CoinWalletOverdraftGuard`（残高不足の事前確認）・
/// `CoinSpendingLimit`（1日あたりの消費上限）とは異なり、本クラスは個々の
/// 消費が短時間に連続していること自体を見る。実際の不審な連続消費への
/// 対応（確認ダイアログ・保護者への通知）はアプリ側の責務とする。
class RapidCoinSpendingStreakDetector {
  const RapidCoinSpendingStreakDetector({
    this.largeAmountThreshold = 100,
    this.streakWindow = const Duration(minutes: 5),
    this.streakThreshold = 3,
  });

  /// これ以上の消費を「大きな消費」とみなす。
  final int largeAmountThreshold;

  /// この時間内に連続した「大きな消費」を1つの連続としてカウントする。
  final Duration streakWindow;

  /// 連続した「大きな消費」がこの回数以上であれば疑わしいと判定する。
  final int streakThreshold;

  /// [eventsNewestFirst]（直近の消費イベントから新しい順の一覧）の先頭
  /// から数えて、[largeAmountThreshold]以上かつ直前のイベントとの時間差が
  /// [streakWindow]以内である消費が連続している回数が[streakThreshold]
  /// 以上であれば、疑わしい連続消費とみなす。
  bool isSuspiciousStreak(List<CoinSpendingEvent> eventsNewestFirst) {
    var consecutiveLargeSpends = 0;
    DateTime? previousSpentAt;

    for (final event in eventsNewestFirst) {
      if (event.amount < largeAmountThreshold) break;
      if (previousSpentAt != null &&
          previousSpentAt.difference(event.spentAt) > streakWindow) {
        break;
      }
      consecutiveLargeSpends++;
      previousSpentAt = event.spentAt;
    }

    return consecutiveLargeSpends >= streakThreshold;
  }
}
