/// コイン残高の純粋な操作。永続化はアプリ/Store側の責務。
class CoinWallet {
  const CoinWallet({this.balance = 0}) : assert(balance >= 0);

  final int balance;

  CoinWallet earn(int amount) {
    if (amount < 0) throw ArgumentError('amount must be non-negative');
    return CoinWallet(balance: balance + amount);
  }

  CoinWallet spend(int amount) {
    if (amount < 0) throw ArgumentError('amount must be non-negative');
    if (amount > balance) throw StateError('insufficient balance');
    return CoinWallet(balance: balance - amount);
  }
}
