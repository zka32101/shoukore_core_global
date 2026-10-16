import 'coin_wallet.dart';

/// コインウォレット（`CoinWallet`）から使用しようとしている額が残高を
/// 超えないかを、例外を投げずに事前確認するための純関数。
/// `CoinWallet.spend`は残高不足時に`StateError`を投げる設計のため、
/// 購入ボタンの有効/無効切り替え等、例外を伴わずに判定したい場面向けに
/// 分離した。実際の購入UI・エラー表示はアプリ側の責務とする。
class CoinWalletOverdraftGuard {
  const CoinWalletOverdraftGuard();

  /// [wallet]の残高が[amount]以上であれば使用可能と判定する。
  bool canAfford({required CoinWallet wallet, required int amount}) {
    return wallet.balance >= amount;
  }
}
