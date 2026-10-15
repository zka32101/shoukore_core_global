/// 直近の購入で1日あたりに消費したコインの集計状態。
class CoinSpendingState {
  const CoinSpendingState({this.spentToday = 0, this.lastSpentAt});

  static const initial = CoinSpendingState();

  /// 現在の集計期間内（`CoinSpendingLimit`が日替わりと判定するまで）に
  /// 消費した合計コイン数。
  final int spentToday;

  /// 最後にコインを消費した時刻。日替わり判定に使う。
  final DateTime? lastSpentAt;
}

/// 1日あたりのコイン消費量に上限を設け、`InventoryManager`での購入が
/// その上限を超えないかを判定する純関数。使いすぎ防止ルールをアプリ側で
/// 簡単に実装できるようにする。実際の「1日」の境界判定は`DailyBoundary`
/// （既存）に委ね、本クラスは渡された[now]が[CoinSpendingState]と同じ日か
/// どうかの単純比較のみ行う。日替わりの判定・リセットはアプリ側が
/// `DailyBoundary`を使って行い、新しい日になったら[CoinSpendingState.initial]
/// から再開する。
class CoinSpendingLimit {
  const CoinSpendingLimit({required this.dailyLimit}) : assert(dailyLimit > 0);

  /// 1日あたりに消費できるコインの上限。
  final int dailyLimit;

  /// [state]に[amount]コインを追加で消費しようとした場合、
  /// [dailyLimit]を超えるかどうかを判定する。
  bool wouldExceedLimit(CoinSpendingState state, int amount) {
    return state.spentToday + amount > dailyLimit;
  }

  /// [state]に[amount]コインの消費を記録した新しい状態を返す。
  /// [dailyLimit]を超える消費は呼び出し側で[wouldExceedLimit]により
  /// 事前に防ぐ想定であり、本メソッド自体は制限を課さない。
  CoinSpendingState recordSpending(CoinSpendingState state, int amount, DateTime now) {
    return CoinSpendingState(spentToday: state.spentToday + amount, lastSpentAt: now);
  }
}
