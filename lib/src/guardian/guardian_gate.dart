import 'dart:math';

/// 保護者ゲートの計算チャレンジ。文言・数字表記はアプリ側がarb/intlで組み立てる
/// （本クラスは数値ロジックのみを持ち、言語・表記には関与しない）。
class GuardianChallenge {
  const GuardianChallenge({required this.a, required this.b, required this.answer});

  final int a;
  final int b;
  final int answer;
}

/// 保護者ゲート（2桁×2桁の乗算）。言語・地域に依らず同一の難易度にする。
class GuardianGate {
  GuardianGate({Random? random}) : _random = random ?? Random();

  final Random _random;

  GuardianChallenge generateChallenge() {
    final a = 10 + _random.nextInt(90);
    final b = 10 + _random.nextInt(90);
    return GuardianChallenge(a: a, b: b, answer: a * b);
  }

  bool verify(GuardianChallenge challenge, int input) => input == challenge.answer;
}
