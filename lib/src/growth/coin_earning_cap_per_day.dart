/// 直近で1日あたりに獲得したコインの集計状態。
class CoinEarningState {
  const CoinEarningState({this.earnedToday = 0, this.lastEarnedAt});

  static const initial = CoinEarningState();

  /// 現在の集計期間内（`CoinEarningCapPerDay`が日替わりと判定するまで）に
  /// 獲得した合計コイン数。
  final int earnedToday;

  /// 最後にコインを獲得した時刻。日替わり判定に使う。
  final DateTime? lastEarnedAt;
}

/// 1日あたりのコイン獲得量に上限を設け、`CoinWallet.earn`で加算しようとする
/// 量がその上限を超えないかを判定する純関数。`CoinSpendingLimit`（使用側の
/// 上限）と対になる獲得側の上限で、過剰な繰り返し操作によるインフレを
/// 防ぐ手がかりとする。実際の「1日」の境界判定は`DailyBoundary`（既存）に
/// 委ね、本クラスは渡された[now]が[CoinEarningState]と同じ日かどうかの
/// 単純比較は行わない（`CoinSpendingLimit`と同様、日替わりのリセットは
/// アプリ側が`DailyBoundary`を使って行い、新しい日になったら
/// [CoinEarningState.initial]から再開する）。
class CoinEarningCapPerDay {
  const CoinEarningCapPerDay({required this.dailyCap}) : assert(dailyCap > 0);

  /// 1日あたりに獲得できるコインの上限。
  final int dailyCap;

  /// [state]に[amount]コインを追加で獲得しようとした場合、
  /// [dailyCap]を超えるかどうかを判定する。
  bool wouldExceedCap(CoinEarningState state, int amount) {
    return state.earnedToday + amount > dailyCap;
  }

  /// [state]に[amount]コインの獲得を記録した新しい状態を返す。
  /// [dailyCap]を超える獲得は呼び出し側で[wouldExceedCap]により
  /// 事前に防ぐ想定であり、本メソッド自体は制限を課さない。
  CoinEarningState recordEarning(CoinEarningState state, int amount, DateTime now) {
    return CoinEarningState(earnedToday: state.earnedToday + amount, lastEarnedAt: now);
  }
}
