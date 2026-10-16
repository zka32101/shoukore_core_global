import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const guard = CoinWalletOverdraftGuard();

  test('残高が使用額以上なら使用可能', () {
    const wallet = CoinWallet(balance: 100);
    expect(guard.canAfford(wallet: wallet, amount: 100), isTrue);
  });

  test('残高が使用額未満なら使用不可', () {
    const wallet = CoinWallet(balance: 50);
    expect(guard.canAfford(wallet: wallet, amount: 100), isFalse);
  });

  test('残高が0でも使用額0なら使用可能', () {
    const wallet = CoinWallet(balance: 0);
    expect(guard.canAfford(wallet: wallet, amount: 0), isTrue);
  });
}
